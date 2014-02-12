class LoadUsernameAndPassword < ActiveRecord::Migration
  def up
  	william = User.find(3)
    william.reload
  	william.password = "william"
  	william.username = "william"
  	william.save()

  	natasha = User.find(1)
    natasha.reload
  	natasha.password = "natasha"
  	natasha.username = "natasha"
  	natasha.save()

  	vilde = User.find(2)
    vilde.reload
  	vilde.password = "vilde"
  	vilde.username = "vilde"
  	vilde.save()
  end

  def down
  	william = User.find(3)
  	william.password = ""
  	william.username = ""
  	william.save()

  	natasha = User.find(1)
  	natasha.password = ""
  	natasha.username = ""
  	natasha.save()

  	vilde = User.find(2)
  	vilde.password = ""
  	vilde.username = ""
  	vilde.save()
  end
end
