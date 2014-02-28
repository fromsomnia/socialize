class Event < ActiveRecord::Base
	before_destroy{ |event|
		for user in event.users
			user.events.delete(event)
		end
	}
	
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
