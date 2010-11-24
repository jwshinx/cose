class Assignment < ActiveRecord::Base
  validates_presence_of :name, :reminder, :category_id, :status_id

  belongs_to :category
  belongs_to :status

  belongs_to :assignable, :polymorphic => true
  belongs_to :note, :class_name => "Note",
                :foreign_key => "assignable_id"
  belongs_to :task, :class_name => "Task",
                :foreign_key => "assignable_id"
  belongs_to :meeting, :class_name => "Meeting",
                :foreign_key => "assignable_id"
  belongs_to :habit, :class_name => "Habit",
                :foreign_key => "assignable_id"
  
  def self.find_all_tasks(id, page, field, ascending)
    @user = User.find(id)
    #@task_assignments = Assignment.find_all_by_assignable_type("Task", 
    #                           :conditions => ["user_id = ?", @user.id],
    #                           :include => :task)

    if ascending == 'true'
      sort_field = field + " ASC"
    else
      sort_field = field + " DESC"
    end
    #  :order => :name,
    logger.debug("===> Assignment.find_all_tasks: 1 #{sort_field}")
    paginate :per_page => 3, :page => page,
      :conditions => ["user_id = ? and assignable_type = 'Task'", @user.id],
      :order => sort_field,
      #:order => :category_id,
      :include => :task

  end
  def self.find_all_notes(id, page)
    @user = User.find(id)
    #@note_assignments = Assignment.find_all_by_assignable_type("Note", 
    #                                                   :include => :note)

    paginate :per_page => 3, :page => page,
      :conditions => ["user_id = ? and assignable_type = 'Note'", @user.id],
      :order => :name,
      :include => :note
  end
  def self.find_all_meetings(id, page)
    @user = User.find(id)
    paginate :per_page => 3, :page => page,
      :conditions => ["user_id = ? and assignable_type = 'Meeting'", @user.id],
      :order => :name,
      :include => :meeting
  end
  def self.find_all_habits(id, page)
    @user = User.find(id)
    paginate :per_page => 3, :page => page,
      :conditions => ["user_id = ? and assignable_type = 'Habit'", @user.id],
      :order => :name,
      :include => :habit
  end
end
