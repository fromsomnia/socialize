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
  	if !session[:logged_in] then
  		@new_user = User.new
  	else
  		redirect_to "/events/logout"
  	end
  end

  def delete_account
  end

  def delete
  	User.destroy(session[:user_id])
  	redirect_to "/events/logout"
  end

  def save
  	@user = User.new(params[:user])
    friend = Friend.new
    friend.user_id = @user.id
    friend.save
  	if @user.save
  		session[:user_id] = @user.id
  		session[:logged_in] = true
		redirect_to "/users/index/#{@user.id}"
	else
		@new_user = User.new
		render :action => "create"
	end
  end

  def edit
  	if params[:id].to_i == session[:user_id].to_i then
  		@user = User.find(session[:user_id])
  	else
  		redirect_to "/users/index"
  	end
  end

  def update
  	@user = User.find(session[:user_id])
  	if @user.update_attributes(params[:user])
		  redirect_to "/users/index/#{@user.id}"
	else
		redirect_to "/users/edit/#{@user.id}"
	end	
  end

  def search
    query = params[:query]
    @results = nil
    User.all do |user|
      if (user.first_name + " " + user.last_name).include?(query) || user.username.include?(query) then
        @results << user
      end
    end
    render json: @results
  end

end