class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.column :first_name, :string
    	t.column :last_name, :string
      	t.column :image, :string
      	t.column :description, :string
      	t.column :username, :string
      	t.column :password, :string
    end
  end
end
