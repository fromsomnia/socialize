class Photo < ActiveRecord::Base
  attr_accessible :name, :filename, :data, :mime_type
end
