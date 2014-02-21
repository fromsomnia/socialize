class UsersController < ApplicationController
  def index
  	if session[:logged_in] then
	  	if params[:id].present? then
	  		@users = User.find(:all, :conditions => "id = #{params[:id]}")
	  	else
        friendships = Friendship.find(:all, :conditions => { :user_id => session[:user_id]})
	  		@users = []
        friendships.each do |friendship|
          if friendship.accepted then
            @users << User.find(friendship.friend.user_id)
          end
        end
	  	end
      @new_friendship = Friendship.new
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

  def request_friend
    @friendship = Friendship.new(params[:friendship])
    @friendship.accepted = false
    if @friendship.save then
      redirect_to "/users/index"
    else
      redirect_to "/users/index"
    end
  end

  def accept_request
    friendship = Friendship.find(:all, :conditions => { :user_id => params[:user_id], :friend_id => Friend.find_by_user_id(session[:user_id]).id })[0]
    friendship.accepted = true
    friendship.save
    inv_friendship = Friendship.new
    inv_friendship.user = User.find(friendship.friend.user_id)
    inv_friendship.friend = Friend.find_by_user_id(friendship.user.id)
    inv_friendship.accepted = true
    inv_friendship.save
    redirect_to "/users/index"
  end

  def ignore_request
    friendship = Friendship.find(:all, :conditions => { :user_id => params[:user_id], :friend_id => Friend.find_by_user_id(session[:user_id]).id })[0]
    Friendship.delete(friendship)
    redirect_to "/users/index"
  end

  def delete_friend
    friendship = Friendship.find(:all, :conditions => { :user_id => params[:user_id], :friend_id => Friend.find_by_user_id(session[:user_id]).id })[0]
    inv_friendship = Friendship.find(:all, :conditions => { :user_id => session[:user_id], :friend_id => Friend.find_by_user_id(params[:user_id])})[0]
    Friendship.delete(friendship)
    Friendship.delete(inv_friendship)
    redirect_to "/users/index"
  end

  def delete
  	User.destroy(session[:user_id])
  	redirect_to "/events/logout"
  end

  def save
  	@user = User.new(params[:user])
  	if @user.save then
  		session[:user_id] = @user.id
  		session[:logged_in] = true
      friend = Friend.new
      friend.user_id = @user.id
      friend.save
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
    @results = []
    User.all.each do |user|
      if (user.first_name + " " + user.last_name).include?(query) || user.username.include?(query) then
        if user.id.to_i != session[:user_id].to_i then
          @results << user
        end
      end
    end
    render json: @results
  end

end