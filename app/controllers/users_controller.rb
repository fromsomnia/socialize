class UsersController < ApplicationController
  def index
  	if session[:logged_in] then
	  	if params[:id].present? then
	  		@users = User.find(:all, :conditions => "id = #{params[:id]}")
	  	else
	  		@users = User.all()
	  	end
	  	@nav_bar = "All Users"
	else
		reset_session
		render "/events/login_screen"
	end
  end

  def create
  	@new_user = User.new
  end

  def save
  	@user = User.new(params[:user])
  	if @user.save
		redirect_to "/users/index/#{@user.id}"
	else
		@new_user = User.new
		render :action => "create"
	end
  end

  def edit
  end

  def update
  end
end