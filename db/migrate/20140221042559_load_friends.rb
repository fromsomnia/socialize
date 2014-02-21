class LoadFriends < ActiveRecord::Migration
  def up
  	natasha = Friend.new
  	natasha.user_id = 1
  	natasha.save

  	vilde = Friend.new
  	vilde.user_id = 2
  	vilde.save

  	william = Friend.new
  	william.user_id = 3
  	william.save
  end

  def down
  	Friend.delete_all
  end
end
