class AddUsernameAndPassword < ActiveRecord::Migration
  def up
  	add_column :users, :username, :string
  	add_column :users, :password, :string

  	william = User.find(3)
  	william.password = "william"
  	william.username = "william"
  	william.save()

  	natasha = User.find(1)
  	natasha.password = "natasha"
  	natasha.username = "natasha"
  	natasha.save()

  	vilde = User.find(2)
  	vilde.password = "vilde"
  	vilde.username = "vilde"
  	vilde.save()

  end

  def down
  	remove_column :users, :username
  	remove_column :users, :password
  end
end
