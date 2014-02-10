class UsersController < ApplicationController
  def index
  	if params[:id].present? then
  		@users = User.find(:all, :conditions => "id = #{params[:id]}")
  	else
  		@users = User.all()
  	end
  	@nav_bar = "All Users"
  end

  def create
  	@new_user = User.new
  end
end