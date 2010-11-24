class AdminController < ApplicationController

  def login
    logger.debug("===> AC login 1 #{params}")
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        logger.debug("===> AC login 2 #{user}")
        logger.debug("===> AC login 3 #{user.id}")
        logger.debug("===> AC login 4 #{session[:user_id]}")
        redirect_to(:action => "index")
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end

  def index
    logger.debug("===> AC index 1 #{session[:user_id]}")
    logger.debug("===> AC index 2 #{session[:user_id]}")

    @user = User.find(session[:user_id])
    logger.debug("===> AC index 3 #{@user.name}")
  end

end
