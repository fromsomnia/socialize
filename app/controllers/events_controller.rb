class EventsController < ApplicationController
  def index
  	if session[:logged_in] then
      friendships = Friendship.find(:all, :conditions => { :user_id => session[:user_id]})
      friends = []
      friendships.each do |friendship|
        if friendship.accepted then
          friends << User.find(friendship.friend.user_id)
        end
      end
      @events = []
      if !params[:id].present? then
        friends.each do |friend|
          events = Event.find(:all, :conditions => { :creator => friend.id})
          events.each do |event|
            @events << event
          end
        end
        me = User.find(session[:user_id])
        me.events.each do |event|
          @events << event
        end
      else
          if friends.include?(User.find(Event.find(params[:id]).creator)) || session[:user_id].to_i == Event.find(params[:id]).creator.to_i then
            @events << Event.find(params[:id])
          end
      end
      @events = @events.sort{|a, b| Event.chronological_sort(a, b)}
    else
    	redirect_to "/events/login_screen"
    end
  end

  def login
  	if !(params[:username].nil?) && !(params[:password].nil?) then
  		user = User.find_by_username(params[:username])
  		if !user.nil? then
  			if user.password.eql?params[:password] then
  				session[:user_id] = user.id
  				session[:logged_in] = true
  				@events = Event.all
  				redirect_to "/events/index"
  			else
  				render "/events/login_screen"
  			end
  		else
  			render "/events/login_screen"
  		end
  	else
  		render "/events/login_screen"
  	end
  end

  def logout
  	reset_session
  	redirect_to "/events/login_screen"

  end

  def login_screen
  	reset_session
  end

  def create
  	if session[:logged_in] then
  		@new_event = Event.new
  	else
  		redirect_to "/events/index"
  	end
  end

  def save
  	@new_event = Event.new(params[:event])
  	if @new_event.save
      User.find(session[:user_id]).events << @new_event
  		#@new_event = Event.new
		redirect_to "/events/index/#{@new_event.id}"
    else
		 #@new_event = Event.new
		 #redirect_to :action => "create"
		render "create"
    end
  end

  def edit
    if params[:id] then
      @event = Event.find(params[:id])
      if @event.creator.to_i == session[:user_id].to_i then
      else
        redirect_to "/events/index"
      end
    else
      redirect_to "/events/index"
    end
  end

  def update
    if params[:id] then
      @event = Event.find(params[:id])
      if @event.update_attributes(params[:event]) then
        redirect_to "/events/index/#{params[:id]}"
      else
        render "edit"
	#redirect_to "/events/edit/#{@event.id}"
      end
    else
      redirect_to "/events/index"
    end
  end

  def update_attendees
    event = Event.find(params[:event_id])
    attendee = User.find(session[:user_id])
    if attendee.events.exists?(event.id) then
      render partial: "user_icon", locals: { attendee: attendee }
    else
      render :nothing => true
    end
  end

  def toggle_attendance
    user = User.find(params[:user_id])
    user.reload
    event = Event.find(params[:event_id])
    puts params
    if user.events.exists?(event.id) then
        user.events.delete(event)
    else
        user.events << event
    end
    render :nothing => true
  end

end
