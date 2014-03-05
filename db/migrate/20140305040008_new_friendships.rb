class NewFriendships < ActiveRecord::Migration
  def up
  	User.all.each do |user|
  		new_friend = Friend.new
  		new_friend.user_id = user.id
  		new_friend.save
  	end

  	User.all.each do |user|
  		User.all.each do |friend|
  			if user.id != friend.id
  				user.friends << Friend.find_by_user_id(friend.id)
  			end
  		end
  		user.save
  	end

  	Friendship.all.each do |friendship|
  		friendship.accepted = true
  		friendship.save
  	end
  end

  def down
  end
end
