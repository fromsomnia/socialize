class Event < ActiveRecord::Base
  attr_accessible :title, :description, :date, :time, :place, :address, :user_id
  has_and_belongs_to_many :users
end
