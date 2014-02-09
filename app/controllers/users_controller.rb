class UsersController < ApplicationController
  def index
  	if params[:id].present? then
  		@users = User.find(:all, :conditions => "id = #{params[:id]}")
  	else
  		@users = User.all()
  	end
  	@nav_bar = "All Users"
  end

  def login

  end

  def logout

  end

  def login_screen

  end

end