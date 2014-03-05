class Event < ActiveRecord::Base
	before_destroy{ |event|
		for user in event.users
			user.events.delete(event)
		end
	}

  def self.currentEvents(list)
    @result = []
    list.each do |item|
      if item.isCurrent? then
        @result << item
      end
    end
    return @result
  end

  def isCurrent?
    puts "Now:"
    puts " Year: " + self.class.year.to_s
    puts " Month: " + self.class.month.to_s
    puts " Current Day: " + self.class.day.to_s
    puts " Compare Day: " + day.to_s
    puts " Hour: " + self.class.hour.to_s
    puts " Min: " + self.class.min.to_s
    if (year == self.class.year - 1 && month == 12 && self.class.month == 1 && day == 31 && self.class.day == 1 && hour >= 21 && self.class.am_pm = "am" && self.class.hour <= 3) then
      return true
    elsif year > self.class.year then
      return true
    elsif year == self.class.year && month > self.class.month then
      return true
    elsif year == self.class.year && month == self.class.month && day > self.class.day then
      return true
    elsif year == self.class.year && month == self.class.month && day == self.class.day && hour + 6 >= self.class.hour then
      return true
    elsif year == self.class.year && month == self.class.month && am_pm.eql?("AM") && hour == 12 && day == self.class.day && hour <= self.class.hour + 8 then
      return true
    elsif year == self.class.year && month == self.class.month && day == self.class.day - 1 then
      if hour >= 21 && self.class.hour <= 3 then
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def year
    date_object = self.date.split('/')
    return date_object[2].to_i
  end

  def month
    date_object = self.date.split('/')
    return date_object[0].to_i
  end

  def day
    date_object = self.date.split('/')
    return date_object[1].to_i
  end

  def am_pm
    time_object = self.time.split(' ')
    return time_object[1]
  end

  def hour
    time_object = self.time.split(' ')
    hour_min = time_object[0].split(':')
    time = hour_min[0].to_i
    if am_pm.eql?("PM") then
      time = time + 12
    end
    return time
  end

  def min
    time_object = self.time.split(' ')
    hour_min = time_object[0].split(':')
    return hour_min[1].to_i
  end

  def self.year
    @timer = Time.now
    return @timer.year.to_i
  end

  def self.month
    @timer = Time.now
    return @timer.month.to_i
  end

  def self.day
    @timer = Time.now
    return @timer.day.to_i
  end

  def self.am_pm
    @timer = Time.now
    return @timer.strftime("%p").to_s
  end

  def self.hour
    @timer = Time.now
    time = @timer.strftime("%H")
    return time.to_i
  end

  def self.min
    @timer = Time.now
    return @timer.min.to_i
  end
	
  attr_accessible :title, :description, :date, :time, :place, :address, :creator
  has_and_belongs_to_many :users

  validates :title, :date, :presence => true

  def self.chronological_sort(a, b)
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


end
