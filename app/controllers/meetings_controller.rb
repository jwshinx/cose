class MeetingsController < ApplicationController
  before_filter :start_logger
  #before_filter :find_user, :only => [:new, :edit, :create, :update]
  before_filter :find_user

  def start_logger
    logger.debug("===> MC START #{params}")
  end
  def find_user
    @user = User.find(session[:user_id])
  end

  # GET /meetings
  # GET /meetings.xml
  def index
    #@meeting_assignments = Assignment.find_all_meetings
    @meeting_assignments = Assignment.find_all_meetings(@user.id, params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @meetings }
    end
  end

  # GET /meetings/1
  # GET /meetings/1.xml
  def show
    @meeting = Meeting.find(params[:id])
    @assignment = Assignment.find(:first,
       :conditions => ["assignable_type = ? and assignable_id = ?",
                         @meeting.class.to_s, @meeting.id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @meeting }
    end
  end

  # GET /meetings/new
  # GET /meetings/new.xml
  def new
    @meeting = Meeting.new
    @statuses = get_status_dropdown
    @categories = get_category_dropdown

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @meeting }
    end
  end

  # GET /meetings/1/edit
  def edit
    @meeting = Meeting.find(params[:id])
    @assignment = Assignment.find(:first,
        :conditions => ["assignable_type = ? and assignable_id = ?",
                          @meeting.class.to_s, @meeting.id])
    @statuses = get_status_dropdown
    @categories = get_category_dropdown
  end

  # POST /meetings
  # POST /meetings.xml
  def create
    @meeting = Meeting.new(params[:meeting])
    @assignment = Assignment.new(params[:assignment])
    @assignment.assignable = @meeting
    @assignment.user_id = @user.id

    respond_to do |format|
      if @meeting.save && @assignment.save
        flash[:notice] = 'Meeting was successfully created.'
        format.html { redirect_to(@meeting) }
        format.xml  { render :xml => @meeting, :status => :created, :location => @meeting }
      else
        flash[:notice] = 'Meeting not created.'
        @statuses = get_status_dropdown
        @categories = get_category_dropdown
        format.html { render :action => "new" }
        format.xml  { render :xml => @meeting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /meetings/1
  # PUT /meetings/1.xml
  def update
    @meeting = Meeting.find(params[:id])
    @assignment = Assignment.find(:first,
       :conditions => ["assignable_type = ? and assignable_id = ?",
                         @meeting.class.to_s, @meeting.id])

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment]) &&
         @meeting.update_attributes(params[:meeting])
        flash[:notice] = 'Meeting was successfully updated.'
        format.html { redirect_to(@meeting) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Meeting was not updated.'
        @statuses = get_status_dropdown
        @categories = get_category_dropdown
        format.html { render :action => "edit" }
        format.xml  { render :xml => @meeting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1
  # DELETE /meetings/1.xml
  def destroy
    @assignment = Assignment.find(params[:id])
    @meeting = @assignment.assignable
    @assignment.destroy
    @meeting.destroy

    respond_to do |format|
      flash[:notice] = 'Meeting was successfully deleted.'
      format.html { redirect_to(meetings_url) }
      format.xml  { head :ok }
    end
  end
end
