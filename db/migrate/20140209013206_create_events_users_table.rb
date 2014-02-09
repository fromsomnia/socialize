class CreateEventsUsersTable < ActiveRecord::Migration
  def up
  	create_table :events_users, :id => false do |t|
    	t.column :user_id, :integer
    	t.column :event_id, :integer

    	natasha = User.find_by_id(1)
		vilde = User.find_by_id(2)
		william = User.find_by_id(3)

		natasha.events << Event.find_by_id(1)
		natasha.save()
		natasha.events << Event.find_by_id(2)
		natasha.save()
		natasha.events << Event.find_by_id(3)
		natasha.save()
		natasha.events << Event.find_by_id(4)
		natasha.save()
		natasha.events << Event.find_by_id(8)
		natasha.save()

		vilde.events << Event.find_by_id(4)
		vilde.save()
		vilde.events << Event.find_by_id(5)
		vilde.save()
		vilde.events << Event.find_by_id(6)
		vilde.save()
		vilde.events << Event.find_by_id(7)
		vilde.save()
		vilde.events << Event.find_by_id(2)
		vilde.save()

		william.events << Event.find_by_id(7)
		william.save()
		william.events << Event.find_by_id(8)
		william.save()
		william.events << Event.find_by_id(9)
		william.save()
		william.events << Event.find_by_id(1)
		william.save()
		william.events << Event.find_by_id(4)
		william.save()
    end
  end

  def down
  	drop_table :events_users
  end
end
