class LoadFriendships < ActiveRecord::Migration
  def up
  	natasha = User.find(1)
  	william = User.find(2)
  	vilde = User.find(3)
  	natasha.friends << Friend.find_by_user_id(william.id)
  	natasha.friends << Friend.find_by_user_id(vilde.id)
  	william.friends << Friend.find_by_user_id(natasha.id)
  	william.friends << Friend.find_by_user_id(vilde.id)
  	vilde.friends << Friend.find_by_user_id(natasha.id)
  	vilde.friends << Friend.find_by_user_id(william.id)
  	natasha.save
  	william.save
  	vilde.save

  	Friendship.all.each do |friendship|
  		friendship.accepted = true
  		friendship.save
  	end

  end

  def down
  	natasha = User.find(1)
  	william = User.find(2)
  	vilde = User.find(3)

  	natasha.friends.delete(Friend.find_by_user_id(william.id))
  	natasha.friends.delete(Friend.find_by_user_id(vilde.id))
  	vilde.friends.delete(Friend.find_by_user_id(william.id))
  	vilde.friends.delete(Friend.find_by_user_id(natasha.id))
  	william.friends.delete(Friend.find_by_user_id(natasha.id))
  	william.friends.delete(Friend.find_by_user_id(vilde.id))
  	natasha.save
  	vilde.save
  	william.save

  end
end
