class EventsController < ApplicationController
  def index
  	if session[:logged_in] then
	  	if params[:id].present? then
	  		@events = Event.find(:all, :conditions => "id = #{params[:id]}")
	  	else
	  		@events = Event.all()
	  	end
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
  				@events = Event.all()
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

end
