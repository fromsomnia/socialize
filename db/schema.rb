# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140221042618) do

  create_table "events", :force => true do |t|
    t.string  "title"
    t.text    "description"
    t.string  "date"
    t.string  "time"
    t.string  "place"
    t.string  "address"
    t.integer "creator"
  end

  create_table "events_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "event_id"
  end

  create_table "friends", :force => true do |t|
    t.integer "user_id"
  end

  create_table "friendships", :force => true do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.boolean "accepted"
  end

  create_table "users", :force => true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "image"
    t.string "description"
    t.string "username"
    t.string "password"
  end

end
