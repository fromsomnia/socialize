class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
    	t.column :title, :string
    	t.column :description, :text
    	t.column :date, :string
    	t.column :time, :string
    	t.column :place, :string
    	t.column :address, :string
    	t.column :creator, :integer
    end
  end
end
