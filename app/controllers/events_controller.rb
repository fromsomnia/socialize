class EventsController < ApplicationController
  def index
  	if session[:logged_in] then
      friends = User.find(session[:user_id]).friends
      @events = []
      friends.each do |friend|
        events = Event.find(:all, :conditions => { :creator => friend.user_id})
        events.each do |event|
          @events << event
        end
      end
	  	if params[:id].present? then
	  		@events = Event.find(:all, :conditions => "id = #{params[:id]}")
	  	end
      @events = @events.sort{|a, b| chronological_sort(a, b)}
    else
    	redirect_to "/events/login_screen"
    end
  end

  def chronological_sort(a, b)
    if a != nil then
      if b != nil then
        if a.date != nil then
          if b.date != nil then
            date1 = a.date.split('/')
            date2 = b.date.split('/')
            year1 = date1[2].to_i
            year2 = date2[2].to_i
            if year1 == year2 then
              month1 = date1[0].to_i
              month2 = date2[0].to_i
              if month1 == month2 then
                day1 = date1[1].to_i
                day2 = date2[1].to_i
                if day1 == day2 then
                  time1 = a.time.split(' ')
                  time2 = b.time.split(' ')
                  if time1[1].eql?(time2[1]) then
                    t1 = time1[0].split(':')
                    t2 = time2[0].split(':')
                    if t2[0].to_i == t1[0].to_i then
                      min1 = t1[1].to_i
                      min2 = t2[1].to_i
                      if min1 == min2 then
                        return 0
                      else
                        return min1 <=> min2
                      end
                    else
                      return t1[0].to_i <=> t2[0].to_i
                    end
                  else
                    return time1[1] <=> time2[1]
                  end
                else
                  return day1 <=> day2
                end
              else
                return month1 <=> month2
              end
            else
              return year1 <=> year2
            end
          else
            return 1
          end
        elsif b.date != nil then
          return -1
        else
          return 0
        end
      else
        return 1
      end
    elsif b != nil then
      return -1
    else
      return 0
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
