class HabitsController < ApplicationController
  before_filter :start_logger
  #before_filter :find_user, :only => [:new, :edit, :create, :update]
  before_filter :find_user

  def start_logger
    logger.debug("===> HC START #{params}")
  end
  def find_user
    @user = User.find(session[:user_id])
  end

  # GET /habits
  # GET /habits.xml
  def index
    #@habits = Habit.find(:all)
    #@habit_assignments = Assignment.find_all_habits
    @habit_assignments = Assignment.find_all_habits(@user.id, params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @habits }
    end
  end

  # GET /habits/1
  # GET /habits/1.xml
  def show
    @habit = Habit.find(params[:id])
    @assignment = Assignment.find(:first,
       :conditions => ["assignable_type = ? and assignable_id = ?",
                         @habit.class.to_s, @habit.id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @habit }
    end
  end

  # GET /habits/new
  # GET /habits/new.xml
  def new
    @habit = Habit.new
    @statuses = get_status_dropdown
    @categories = get_category_dropdown

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @habit }
    end
  end

  # GET /habits/1/edit
  def edit
    @habit = Habit.find(params[:id])
    @assignment = Assignment.find(:first,
       :conditions => ["assignable_type = ? and assignable_id = ?",
                         @habit.class.to_s, @habit.id])
    
    @statuses = get_status_dropdown
    @categories = get_category_dropdown
  end

  # POST /habits
  # POST /habits.xml
  def create
    @habit = Habit.new(params[:habit])
    @assignment = Assignment.new(params[:assignment])
    @assignment.assignable = @habit
    @assignment.user_id = @user.id

    respond_to do |format|
      if @habit.save && @assignment.save
        flash[:notice] = 'Habit was successfully created.'
        format.html { redirect_to(@habit) }
        format.xml  { render :xml => @habit, :status => :created, :location => @habit }
      else
        flash[:notice] = 'Habit not created.'
        @statuses = get_status_dropdown
        @categories = get_category_dropdown
        format.html { render :action => "new" }
        format.xml  { render :xml => @habit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /habits/1
  # PUT /habits/1.xml
  def update
    @habit = Habit.find(params[:id])
    @assignment = Assignment.find(:first,
       :conditions => ["assignable_type = ? and assignable_id = ?",
                         @habit.class.to_s, @habit.id])

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment]) && 
         @habit.update_attributes(params[:habit])
        flash[:notice] = 'Habit was successfully updated.'
        format.html { redirect_to(@habit) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Habit was not updated.'
        @statuses = get_status_dropdown
        @categories = get_category_dropdown
        format.html { render :action => "edit" }
        format.xml  { render :xml => @habit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /habits/1
  # DELETE /habits/1.xml
  def destroy
    #@habit = Habit.find(params[:id])
    #@habit.destroy

    @assignment = Assignment.find(params[:id])
    @habit = @assignment.assignable
    @assignment.destroy
    @habit.destroy

    respond_to do |format|
      flash[:notice] = 'Habit was successfully deleted.'
      format.html { redirect_to(habits_url) }
      format.xml  { head :ok }
    end
  end
end
