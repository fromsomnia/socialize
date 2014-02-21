class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
    	t.column :user_id, :integer
    end
  end
end
