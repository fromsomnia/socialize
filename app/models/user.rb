class User < ActiveRecord::Base

validates :last_name, :first_name, :username, :password, :presence => true
validates :username, :uniqueness => { :message => "already in use" }

	before_destroy { |user|
		Event.destroy_all("creator = #{user.id}")
		for event in user.events
			event.users.delete(user)
		end
	}
  attr_accessible :first_name, :last_name, :image_url, :description, :username, :password
  has_and_belongs_to_many :events
  has_many :friendships
  has_many :friends, through: :friendships

end
