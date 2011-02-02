# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101228131521) do

  create_table "courses", :force => true do |t|
    t.integer  "department_id"
    t.string   "number"
    t.string   "days"
    t.string   "term"
    t.integer  "year"
    t.text     "description"
    t.string   "name"
    t.decimal  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses_users", :id => false, :force => true do |t|
    t.integer "user_id",   :null => false
    t.integer "course_id", :null => false
  end

  create_table "departments", :force => true do |t|
    t.integer  "school_id"
    t.string   "name"
    t.string   "abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrollments", :force => true do |t|
    t.integer  "school_id"
    t.integer  "user_id"
    t.integer  "start_year"
    t.integer  "end_year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grades", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "letter"
    t.decimal  "points_received"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "iratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.integer  "easiness"
    t.integer  "interest"
    t.integer  "work_load"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "course_id"
    t.string   "name"
    t.string   "category"
    t.datetime "due_date"
    t.integer  "points"
    t.float    "weight"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.integer  "parent_id"
    t.string   "title"
    t.text     "body"
    t.string   "tags"
    t.datetime "commented_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts_tags", :id => false, :force => true do |t|
    t.integer "post_id", :null => false
    t.integer "tag_id",  :null => false
  end

  create_table "ratings", :force => true do |t|
    t.integer  "easiness"
    t.integer  "interest"
    t.integer  "work_load"
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.string   "abbr"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "enrollment_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "privilege"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "fb_id"
    t.integer  "enrollment_id"
  end

end
