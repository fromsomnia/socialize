class User < ActiveRecord::Base

	before_destroy { |user|
		Event.destroy_all("creator = #{user.id}")
		for event in user.events
			event.users.delete(user)
		end
	}

	attr_accessible :first_name, :last_name, :image, :description, :username, :password, :password_digest, :salt
	has_and_belongs_to_many :events
	has_many :friendships
	has_many :friends, through: :friendships

	def password_valid?(value)
        password_digest.eql?(Digest::SHA1.hexdigest(value.to_s + "" + salt.to_s))
    end
    
    def password
        @password
    end
    
    def password=(password)
        sal = Random.new.rand.to_s
        p_digest = Digest::SHA1.hexdigest(password.to_s + "" + sal.to_s)
        hash = {:salt => sal, :password_digest => p_digest}
        update_attributes(hash)
        @password = password
    end

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

	def getNumFriendRequests
		current_friend_id = Friend.find_by_user_id(self.id)
		requests = Friendship.find(:all, :conditions => { :friend_id => current_friend_id, :accepted => false})
		return requests.size
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

	def getNumEventsAttendingNow
		@eventsAttendingNow = []
		events = self.getEventsAttending
		events.each do |event|
			if event.isNow? then
				@eventsAttendingNow << event
			end
		end
		return @eventsAttendingNow.size
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



	validates :last_name, :first_name, :username, :presence => true
	validates :password, :presence => { :message => "please provide your password" }
	validates :username, :uniqueness => { :message => "already in use" }

end
