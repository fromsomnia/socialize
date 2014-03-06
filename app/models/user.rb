class User < ActiveRecord::Base

	before_destroy { |user|
		Event.destroy_all("creator = #{user.id}")
		for event in user.events
			event.users.delete(user)
		end
	}

	attr_accessible :first_name, :last_name, :image, :description, :username, :password
	has_and_belongs_to_many :events
	has_many :friendships
	has_many :friends, through: :friendships

	def getFriends
		friendships = Friendship.find(:all, :conditions => { :user_id => self.id })
		@friends = []
		friendships.each do |friendship|
			if friendship.accepted then
				@friends << User.find(friendship.friend.user_id)
			end
		end
		return @friends
	end

	def canViewEvent?(event)
		return self.getCurrentEvents.include?(event)
	end

	def getEventsByUser
		@userEvents = Event.find(:all, :conditions => { :creator => self.id })
		return @userEvents
	end

	def getCurrentEventsByUser
		@currentEventsByUser = []
		events = self.getEventsByUser
		events.each do |event|
			if event.isCurrent? then
				@currentEventsByUser << event
			end
		end
		return @currentEventsByUser
	end

	def getEventsAttending
		return self.events
	end

	def getCurrentEventsAttending
		@currentEventsAttending = []
		events = self.getEventsAttending
		events.each do |event|
			if event.isCurrent? then
				@currentEventsAttending << event
			end
		end
		return @currentEventsAttending
	end



	def getAllEvents
		@events = []
		friends = self.getFriends
		friends.each do |friend|
          events = Event.find(:all, :conditions => { :creator => friend.id})
          events.each do |event|
            @events << event
          end
        end
        events = self.getEventsByUser
        events.each do |event|
          @events << event
        end
        return @events
    end

    def getCurrentEvents
    	@currentEvents = []
    	allEvents = self.getAllEvents
    	allEvents.each do |event|
    		if event.isCurrent? then
    			@currentEvents << event
    		end
    	end
    	return @currentEvents
    end

    def self.alphabetical_sort(a, b)
	    if a != nil then
	    	if b != nil then
	        	name1 = (a.first_name + " " + a.last_name).downcase
	        	name2 = (b.first_name + " " + b.last_name).downcase
	        	if name1.length > name2.length then
	        		name1 = name1.slice(0, name2.length)
	        	else
	        		name2 = name2.slice(0, name1.length)
	        	end
	        	return name1 <=> name2
	    	else
	    		return 1
	    	end
	    elsif b != nil then
	    	return -1
	    else
	    	return 0
	    end
	end



	validates :last_name, :first_name, :username, :password, :presence => true
	validates :username, :uniqueness => { :message => "already in use" }

end
