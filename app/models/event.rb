class Event < ActiveRecord::Base
	before_destroy{ |event|
		for user in event.users
			user.events.delete(event)
		end
	}
	
  attr_accessible :title, :description, :date, :time, :place, :address, :creator
  has_and_belongs_to_many :users
end
