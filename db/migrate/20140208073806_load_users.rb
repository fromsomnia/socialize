class LoadUsers < ActiveRecord::Migration
  def up
  	natasha = User.new(:first_name => "Natasha", :last_name => "Prats", 
  		:image => "/assets/profile_pics/profile-default.jpg",
  		:description => "Natasha describes herself as a hummingbird",
      :username => "natasha",
      :password => "natasha")
  	natasha.save(:validate => false)
  	vilde = User.new(:first_name => "Vilde", :last_name => "Opsal",
  		:image => "/assets/profile_pics/profile-default.jpg",
  		:description => "Vilde is from Norway",
      :username => "vilde",
      :password => "vilde")
  	vilde.save(:validate => false)
  	william = User.new(:first_name => "William", :last_name => "Chidyausiku",
  		:image => "/assets/profile_pics/profile-default.jpg",
  		:description => "William hopes this works!",
      :username => "william",
      :password => "william")
  	william.save(:validate => false)
  end

  def down
  	User.delete_all
  end
end
