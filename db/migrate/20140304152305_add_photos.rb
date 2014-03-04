class AddPhotos < ActiveRecord::Migration
  def up
  	@data = File.read("#{Rails.root}/app/assets/images/profile_pics/profile-default.jpg")
  	photo = Photo.new(
  		:name => "profile-default",  
  		:data => @data,
  		:filename => "profile-default.jpg",
  		:mime_type => "image/jpeg")
  	photo.save(:validate => false)
  end

  def down
  	Photo.delete_all
  end
end