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
      @users = @users.sort{|a, b| User.alphabetical_sort(a, b)}
      @new_friendship = Friendship.new
	  	@nav_bar = "All Users"
	else
		reset_session
		render "/events/login_screen"
	end
  end

  def create
  	if !session[:logged_in] then
  		@new_user = User.new(params[:new_user])
=begin
		if @new_user.save
			redirect_to new_user_path, :notice => "Account created"
		else
			render "create"
		end
=end
  	else
  		redirect_to "/events/logout"
  	end
  end

  def delete_account
  end

  def request_friend
    @friendship = Friendship.new(params[:friendship])
    inv_friendship = Friendship.find(:all, :conditions => { :user_id => @friendship.friend.user_id, :friend_id => Friend.find_by_user_id(@friendship.user.id).id })[0]
    @friendship.accepted = false
    if inv_friendship != nil then
      @friendship.accepted = true
      inv_friendship.accepted = true
      @friendship.save
      inv_friendship.save
      flash[:notice] = "Friend Added"
      redirect_to "/users/index"
    elsif @friendship.save then
      flash[:notice] = "Friendship Requested"
      redirect_to "/users/index"
    else
      flash[:notice] = "Friend Action Failed"
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
    flash[:notice] = "Friend Added"
    redirect_to "/users/index"
  end

  def ignore_request
    friendship = Friendship.find(:all, :conditions => { :user_id => params[:user_id], :friend_id => Friend.find_by_user_id(session[:user_id]).id })[0]
    Friendship.delete(friendship)
    flash[:notice] = "Request Ignored"
    redirect_to "/users/index"
  end

  def delete_friend
    friend_id = params[:user_id].to_i
    @user = User.find(friend_id)
  end

  def remove_friend
    friendship = Friendship.find(:all, :conditions => { :user_id => params[:user_id], :friend_id => Friend.find_by_user_id(session[:user_id]).id })[0]
    inv_friendship = Friendship.find(:all, :conditions => { :user_id => session[:user_id], :friend_id => Friend.find_by_user_id(params[:user_id])})[0]
    Friendship.delete(friendship)
    Friendship.delete(inv_friendship)
    flash[:notice] = "Friend Removed"
    redirect_to "/users/index"
  end

  def delete
  	User.destroy(session[:user_id])
    flash[:notice] = "Account Deleted"
  	redirect_to "/events/logout"
  end

  def save
    if(params[:user][:image] != nil) then
      image_name = params[:user][:image].original_filename
      just_filename = File.basename(image_name) 
      just_filename = just_filename.sub(/[^\w\.\-]/,'_')
      save_name = "#{params[:user][:last_name].sub(/[^\w\.\-]/,'_')}-#{params[:user][:first_name].sub(/[^\w\.\-]/,'_')}-profile-pic"
      @photo = Photo.new() do |t|
        t.name      = save_name
        t.data      = params[:user][:image].read
        t.filename  = just_filename
        t.mime_type = params[:user][:image].content_type
      end
      params[:user][:image] = ""
    else
      params[:user][:image] = Photo.find_by_name("profile-default").id
    end
  	@new_user = User.new(params[:user])
  	if @new_user.save then
      if @photo != nil then
        @photo.save
        @new_user.image = @photo.id
        @new_user.save
      end
  		session[:user_id] = @new_user.id
  		session[:logged_in] = true
      friend = Friend.new
      friend.user_id = @new_user.id
      friend.save
      flash[:notice] = "Account Created"
		redirect_to "/users/index/#{@new_user.id}"
	else
		#@new_user = User.new
    flash[:notice] = "Account Creation Failed"
		render "create"
		#render 'new'
	end
  end

  def edit
  	if params[:id].to_i == session[:user_id].to_i then
  		@user = User.find(session[:user_id])
  	else
      flash[:notice] = "Cannot Edit Account"
  		redirect_to "/users/index"
  	end
  end

  def update
    @user = User.find(session[:user_id])
    if(params[:user][:image] != nil) then
      image_name = params[:user][:image].original_filename
      just_filename = File.basename(image_name) 
      just_filename = just_filename.sub(/[^\w\.\-]/,'_')
      save_name = "#{@user.last_name.sub(/[^\w\.\-]/,'_')}-#{@user.first_name.sub(/[^\w\.\-]/,'_')}-profile-pic"
      @photo = Photo.new() do |t|
        t.name      = save_name
        t.data      = params[:user][:image].read
        t.filename  = just_filename
        t.mime_type = params[:user][:image].content_type
      end
      params[:user][:image] = ""
    end
    if !@user.password_valid?(params[:user][:password]) then
      flash[:notice] = "Incorrect Password"
      render "edit"
    else
      puts params[:user].to_json
    	if @user.update_attributes(params[:user])
        if @photo != nil then
          @photo.save 
          @user.image = @photo.id
          @user.save
        end
        flash[:notice] = "Account Updated"
  		  redirect_to "/users/index/#{@user.id}"
  	   else
  		#redirect_to "/users/edit/#{@user.id}"
        flash[:notice] = "Account Update Failed"
  		  render "edit"
  	   end	
    end
  end

  def create_photo
    # build a photo and pass it into a block to set other attributes
    @photo = Photo.new(params[:photo]) do |t|
      if params[:photo][:data]
        t.data      = params[:photo][:data].read
        t.filename  = params[:photo][:data].original_filename
        t.mime_type = params[:photo][:data].content_type
      end
    end
    
    # normal save
    @photo.save
  end

  def destroy_photo
    @photo = Photo.find(params[:id])
    @photo.destroy
  end

  def serve_photo
    @photo = Photo.find(params[:id])
    send_data(@photo.data, :type => @photo.mime_type, :filename => "#{@photo.name}.jpg", :disposition => "inline")
  end

  def search_results
    query = ""
    if params[:query].present? then
      query = params[:query].downcase
    end
    @results = []
    if !query.blank? then
      User.all.each do |user|
        if (user.first_name + " " + user.last_name).downcase.include?(query) || user.username.downcase.include?(query) then
          if user.id.to_i != session[:user_id].to_i then
            @results << user
          end
        end
      end
      @results = @results.sort{|a, b| User.alphabetical_sort(a, b)}
    end
  end

  def search
    query = params[:query].downcase
    @results = []
    User.all.each do |user|
      if (user.first_name + " " + user.last_name).downcase.include?(query) || user.username.downcase.include?(query) then
        if user.id.to_i != session[:user_id].to_i then
          @results << user
        end
      end
    end
    @results = @results.sort{|a, b| User.alphabetical_sort(a, b)}
    render json: @results
  end

end
