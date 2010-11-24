class TasksController < ApplicationController
  before_filter :start_logger
  #before_filter :find_user, :only => [:index, :new, :edit, :create, :update]
  before_filter :find_user

  def start_logger
    logger.debug("===> TC START #{params}")
  end

  def find_user
    @user = User.find(session[:user_id])
  end

  def sort_by_category
    logger.debug("===> TC.sort_by_category #{params}")
    @task_assignments = Assignment.find_all_tasks(
          @user.id, params[:page], "category_id", params[:ascending]) 
    respond_to do |format|
      format.html { render :action => "index" }
      #format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end

  end
  # GET /tasks
  # GET /tasks.xml
  def index
    #@tasks = Task.find(:all)
    #@tasks = Task.find_all_tasks
    
    #@task_assignments = Assignment.find_all_tasks(@user.id, params[:page]) 
    @task_assignments = Assignment.find_all_tasks(
                           @user.id, params[:page], "name", true) 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @task_assignments }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])
    @assignment = Assignment.find(:first, 
       :conditions => ["assignable_type = ? and assignable_id = ?", 
                         @task.class.to_s, @task.id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new
    @statuses = get_status_dropdown
    @categories = get_category_dropdown

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit

    @task = Task.find(params[:id])
    @assignment = Assignment.find(:first, 
       :conditions => ["assignable_type = ? and assignable_id = ?", 
                         @task.class.to_s, @task.id])

    #@assignment = Assignment.find(params[:id])
    #@task = @assignment.assignable

    @statuses = get_status_dropdown
    @categories = get_category_dropdown
  end

  # POST /tasks
  # POST /tasks.xml
  def create

    @task = Task.new(params[:task])
    @assignment = Assignment.new(params[:assignment])
    @assignment.assignable = @task
    @assignment.user_id = @user.id

    respond_to do |format|
      if @task.save && @assignment.save
        logger.debug("===> TC.create 2 saved")
        flash[:notice] = 'Task was successfully created.'
        format.html { redirect_to(@task) }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        flash[:notice] = 'Task not created.'
        @statuses = get_status_dropdown
        @categories = get_category_dropdown
        logger.debug("===> TC.create 3 not saved")
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])
    @assignment = Assignment.find(:first, 
       :conditions => ["assignable_type = ? and assignable_id = ?", 
                         @task.class.to_s, @task.id])

    #@assignment = Assignment.find(params[:id])
    #@task = @assignment.assignable

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment]) && 
         @task.update_attributes(params[:task])
        flash[:notice] = 'Task was successfully updated.'
        format.html { redirect_to(@task) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Task was not updated.'
        @statuses = get_status_dropdown
        @categories = get_category_dropdown
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy

    #@task = Task.find(params[:id])
    #@assignment = Assignment.find(:first, 
    #   :conditions => ["assignable_type = ? and assignable_id = ?", 
    #                     @task.class.to_s, @task.id])

    @assignment = Assignment.find(params[:id])
    @task = @assignment.assignable
    @assignment.destroy
    @task.destroy

    respond_to do |format|
      flash[:notice] = 'Task was successfully deleted.'
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end
end
