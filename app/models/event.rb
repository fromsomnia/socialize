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

  def isNow?
    return (self.isCurrent? && self.getDateTime <= Time.now)
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
      if hour.to_i != 12 then
        hour = hour + 12
      end
    end
    Time.zone = TZInfo::Timezone.get('America/Los_Angeles')
    dateTime = Time.new(year, month, day, hour, min, 0, "-08:00")
    return dateTime
  end

  def getRelativeTime
    Time.zone = TZInfo::Timezone.get('America/Los_Angeles')
    time = self.getDateTime
    now = Time.zone.now
    diff = time - now
    if diff.abs < (60*60) then
      time = (diff/60).to_i.abs
      if diff < 0 then
        return "started " + time.to_s + " min ago"
      else
        return "in " + time.to_s + " min"
      end
    elsif diff.abs < (60*60*24) then
      time = (diff/(60*60)).to_i.abs
      if diff < 0 then
        if time.abs == 1 then
          return "started " + time.to_s + " hour ago"
        else
          return "started " + time.to_s + " hours ago"
        end
      else
        if time.abs == 1 then
          return "in " + time.to_s + " hour"
        else
          return "in " + time.to_s + " hours"
        end
      end
    elsif diff.abs < (60*60*24*7) then
      time = (diff/(60*60*24)).to_i.abs
      if time == 1 then
        return ("in " + time.to_s + " day")
      else
        return ("in " + time.to_s + " days")
      end
    elsif diff.abs < (60*60*24*30) then
      time = (diff/(60*60*24*7)).to_i.abs
      if time == 1 then
        return "in " + time.to_s + " week"
      else
        return "in " + time.to_s + " weeks"
      end
    elsif diff.abs < (60*60*24*365) then
      time = (diff/(60*60*24*30)).to_i.abs
      if time == 1 then
        return "in " + time.to_s + " month"
      else 
        return "in " + time.to_s + " months"
      end
    else
      time = (diff/(60*60*24*365)).to_i.abs
      if time == 1 then
        return "in 1 year"
      else
        return "in " + time.to_s + " years"
      end
    end
  end

  def getRelativeDate
    Time.zone = TZInfo::Timezone.get('America/Los_Angeles')
    time = self.getDateTime
    now = Time.zone.now
    if ((now.to_i - (60 * 60 * 3))..now.to_i) === time.to_i then
      return "NOW"
    elsif (now.to_i..(now.to_i + 60 * 60 * 6)) === time.to_i then
      return "SOON"
    elsif time.to_i > (now.to_i + (60 * 60 * 6)) then
      return "LATER"
    else
      return ""
    end
  end

  def getTimeColorClass
    Time.zone = TZInfo::Timezone.get('America/Los_Angeles')
    time = self.getDateTime
    now = Time.zone.now
    if ((now.to_i - (60 * 60 * 3))..now.to_i) === time.to_i then
      return "happening-now"
    elsif (now.to_i..(now.to_i + 60 * 60 * 6)) === time.to_i then
      return "happening-soon"
    elsif time.to_i > (now.to_i + (60 * 60 * 6)) then
      return "happening-later"
    else
      return "happening-default"
    end
  end

  def getPurtyDate
    Time.zone = TZInfo::Timezone.get('America/Los_Angeles')
    time = self.getDateTime
    now = Time.zone.now
    if time.year == now.year && time.yday == now.yday - 1 then
      return "YESTERDAY"
    elsif time.year == now.year && time.yday == now.yday then
      return "TODAY"
    elsif time.year == now.year && time.yday == now.yday + 1 then
      return "TOMORROW"
    elsif time.year == now.year && time.yday - now.yday <= 7 then
      return time.strftime("%A")
    else
      return self.date
    end
  end

  def getPurtyTime
    return self.time
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
