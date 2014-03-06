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

	def getEvents
		@events = []
		friends = self.getFriends
		friends.each do |friend|
          events = Event.find(:all, :conditions => { :creator => friend.id})
          events.each do |event|
            @events << event
          end
        end
        events = Event.find(:all, :conditions => { :creator => self.id })
        events.each do |event|
          @events << event
        end
        return @events
    end

    def getCurrentEvents
    	@currentEvents = []
    	allEvents = self.getEvents
    	allEvents.each do |event|
    		if event.isCurrent? then
    			@currentEvents << event
    		end
    	end
    	return @currentEvents
    end



	validates :last_name, :first_name, :username, :password, :presence => true
	validates :username, :uniqueness => { :message => "already in use" }

end
