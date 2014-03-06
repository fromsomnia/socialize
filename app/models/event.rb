class Event < ActiveRecord::Base
	before_destroy{ |event|
		for user in event.users
			user.events.delete(event)
		end
	}

  def self.getCurrentEvents(list)
    @result = []
    list.each do |item|
      if item.isCurrent? then
        @result << item
      end
    end
    return @result
  end

  def isCurrent?
    return self.getDateTime + (60 * 60 * 3) >= Time.now
  end
	
  attr_accessible :title, :description, :date, :time, :place, :address, :creator
  has_and_belongs_to_many :users

  validates :title, :date, :presence => true

  def getDateTime
    date = self.date.split('/')
    year = date[2].to_i
    month = date[0].to_i
    day = date[1].to_i
    time = self.time.split(' ')
    time_component = time[0].split(':')
    hour = time_component[0].to_i
    min = time_component[1].to_i
    if time[1].eql?("pm") then
      hour = hour + 12
    end
    dateTime = Time.new(year, month, day, hour, min)
    return dateTime
  end

  def self.chronological_sort(a, b)
    if a != nil then
      if b != nil then
        if a.date != nil then
          if b.date != nil then
            return a.getDateTime <=> b.getDateTime
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
end
