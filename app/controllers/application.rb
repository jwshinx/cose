# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :authorize, :except => :login
  #before_filter :find_user, :only => [ :get_category_dropdown,
  #                                     :get_status_dropdown ]

  helper :all # include all helpers, all the time
  layout "assignments"

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery  :secret => 'ffc95b8d22efbc56f97ab5ac55f95d21'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

=begin
  def find_user
    logger.debug("===> AppC find_user 1: #{session[:user_id]}")
    @user = User.find(session[:user_id])
  end
=end

  def get_category_dropdown
    logger.debug("===> AppC get_category_dropdown")
    @categories = Category.find(:all, 
                            :conditions => ["user_id = ?", @user.id],
                            :order => "name ASC").map do |c|
      [c.name, c.id]
    end
  end
  def get_status_dropdown
    logger.debug("===> AppC get_status_dropdown")
    @statuses = Status.find(:all, 
                            :conditions => ["user_id = ?", @user.id],
                            :order => "name ASC").map do |s|
      [s.name, s.id]
    end
  end

protected
  def authorize
    unless User.find_by_id(session[:user_id])
      flash[:notice] = "Please log in"
      redirect_to :controller => 'admin', :action => 'login'
    end
  end
end
