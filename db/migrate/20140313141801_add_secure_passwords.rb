class AddSecurePasswords < ActiveRecord::Migration
	class User < ActiveRecord::Base
    end

    def change
        add_column :users, :password_digest, :string
        add_column :users, :salt, :string
        User.reset_column_information
        for user in User.all do
        	puts "password: " + user.to_json
            user.salt = Random.new.rand.to_s
            concat = user.password + "" + user.salt
            user.password_digest = Digest::SHA1.hexdigest(concat)
            user.save
        end
        remove_column :users, :password
    end
end
