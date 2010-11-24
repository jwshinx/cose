class AssignmentsController < ApplicationController
  before_filter :start_logger
  before_filter :find_user, :include => [:index]

  def find_user
    @user = User.find(session[:user_id])
  end
  def start_logger
    logger.debug("===> AC START #{params}")
  end

  # GET /assignments
  # GET /assignments.xml
  def index
    @assignments = Assignment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assignments }
    end
  end

  # GET /assignments/1
  # GET /assignments/1.xml
  def show
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assignment }
    end
  end

  # GET /assignments/new
  # GET /assignments/new.xml
  def new
    @assignment = Assignment.new
    @task = Task.new

    @statuses = Status.find(:all, :order => "name ASC").map do |s|
      [s.name, s.id]
    end
    @categories = Category.find(:all, :order => "name ASC").map do |c|
      [c.name, c.id]
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assignment }
    end
  end

  # GET /assignments/1/edit
  def edit
    @assignment = Assignment.find(params[:id])
    @task = @assignment.assignable
    @statuses = Status.find(:all, :order => "name ASC").map do |s|
      [s.name, s.id]
    end
    @categories = Category.find(:all, :order => "name ASC").map do |c|
      [c.name, c.id]
    end
  end

  # POST /assignments
  # POST /assignments.xml
  def create

    @assignment = Assignment.new(params[:assignment])
    #@task = @assignment.assignable.build(params[:task])
    @task = Task.new(params[:task])
    @assignment.assignable = @task

    respond_to do |format|
      #if @task.save
      # note: save parent first;  if child saved first, and parent errors out
      # than no good.  gonna save both.  save parent first; if that errors
      # out, it never looks at child
      if @task.save && @assignment.save
        logger.debug("===> AC.create 4 saved")
        flash[:notice] = 'Assignment was successfully created.'
        format.html { redirect_to(@assignment) }
        format.xml  { render :xml => @assignment, :status => :created, :location => @assignment }
      else
        flash[:notice] = 'Assignment/Task not created.'
        logger.debug("===> AC.create 5 not saved")
        @statuses = Status.find(:all, :order => "name ASC").map do |s|
          [s.name, s.id]
        end
        @categories = Category.find(:all, :order => "name ASC").map do |c|
          [c.name, c.id]
        end
        format.html { render :action => "new" }
        format.xml  { render :xml => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assignments/1
  # PUT /assignments/1.xml
  def update
    @assignment = Assignment.find(params[:id])
    @task = @assignment.assignable

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment]) &&
         @task.update_attributes(params[:task])
        flash[:notice] = 'Assignment was successfully updated.'
        format.html { redirect_to(@assignment) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Assignment/Task not updated.'
        @statuses = Status.find(:all, :order => "name ASC").map do |s|
          [s.name, s.id]
        end
        @categories = Category.find(:all, :order => "name ASC").map do |c|
          [c.name, c.id]
        end
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.xml
  def destroy
    @assignment = Assignment.find(params[:id])
    @parent = @assignment.assignable
    @assignment.destroy
    @parent.destroy

    respond_to do |format|
      flash[:notice] = 'Assignment was successfully deleted.'
      format.html { redirect_to(assignments_url) }
      format.xml  { head :ok }
    end
  end
end
