class NewEvents < ActiveRecord::Migration
  def up
  	Event.delete_all
  end

  def down
  end
end
