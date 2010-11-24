class NotesController < ApplicationController
  before_filter :start_logger
  #before_filter :find_user, :only => [:new, :edit, :create, :update]
  before_filter :find_user

  def start_logger
    logger.debug("===> NC START #{params}")
  end
  def find_user
    @user = User.find(session[:user_id])
  end

  # GET /notes
  # GET /notes.xml
  def index
    #@notes = Note.find(:all)
    #@note_assignments = Assignment.find_all_notes
    @note_assignments = Assignment.find_all_notes(@user.id, params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.xml
  def show
    @note = Note.find(params[:id])
    @assignment = Assignment.find(:first,
      :conditions => ["assignable_type = ? and assignable_id = ?",
                        @note.class.to_s, @note.id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/new
  # GET /notes/new.xml
  def new
    @note = Note.new
    @statuses = get_status_dropdown
    @categories = get_category_dropdown

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
    @assignment = Assignment.find(:first,
      :conditions => ["assignable_type = ? and assignable_id = ?",
                        @note.class.to_s, @note.id])

    #@assignment = Assignment.find(params[:id])
    #@note = @assignment.assignable 

    @statuses = get_status_dropdown
    @categories = get_category_dropdown
  end

  # POST /notes
  # POST /notes.xml
  def create
    @note = Note.new(params[:note])
    @assignment = Assignment.new(params[:assignment])
    @assignment.assignable = @note
    @assignment.user_id = @user.id

    respond_to do |format|
      if @note.save && @assignment.save
        logger.debug("===> NC.create saved")
        flash[:notice] = 'Note was successfully created.'
        format.html { redirect_to(@note) }
        format.xml  { render :xml => @note, :status => :created, :location => @note }
      else
        flash[:notice] = 'Note not created.'
        @statuses = get_status_dropdown
        @categories = get_category_dropdown
        format.html { render :action => "new" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    #@assignment = Assignment.find(params[:id])
    #@note = @assignment.assignable
 
    @note = Note.find(params[:id])
    @assignment = Assignment.find(:first,
      :conditions => ["assignable_type = ? and assignable_id = ?",
                        @note.class.to_s, @note.id])

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment]) && 
         @note.update_attributes(params[:note])
        flash[:notice] = 'Note was successfully updated.'
        format.html { redirect_to(@note) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Note was not updated.'
        @statuses = get_status_dropdown
        @categories = get_category_dropdown
        format.html { render :action => "edit" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    @assignment = Assignment.find(params[:id])
    @note = @assignment.assignable
    @assignment.destroy
    @note.destroy

    respond_to do |format|
      flash[:notice] = 'Note was successfully deleted.'
      format.html { redirect_to(notes_url) }
      format.xml  { head :ok }
    end
  end
end
