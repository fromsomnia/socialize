class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :image_url, :description
  has_and_belongs_to_many :events
  has_many :events
end
