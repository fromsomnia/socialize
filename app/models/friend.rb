class Friend < ActiveRecord::Base
  attr_accessible :user_id
  belongs_to :user
  has_many :friendships
  has_many :users, through: :friendships
end
