class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :image_url, :description, :password, :username
  has_and_belongs_to_many :events
end
