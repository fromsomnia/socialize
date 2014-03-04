class AssignPhotos < ActiveRecord::Migration
  def change	
	  william = User.find(3)
	  natasha = User.find(1)
	  vilde = User.find(2)

	  william.image = Photo.find_by_name("profile-default").id
	  natasha.image = Photo.find_by_name("profile-default").id
	  vilde.image = Photo.find_by_name("profile-default").id

	  william.save
	  natasha.save
	  vilde.save
  end
end
