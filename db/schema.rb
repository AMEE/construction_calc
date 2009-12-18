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

ActiveRecord::Schema.define(:version => 20091218142732) do

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commutes", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "amee_profile_item_id"
    t.string   "commute_type"
    t.float    "carbon_output_cache"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commutes", ["project_id"], :name => "index_commutes_on_project_id"

  create_table "deliveries", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "amee_profile_item_id"
    t.string   "delivery_type"
    t.float    "carbon_output_cache"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deliveries", ["project_id"], :name => "index_deliveries_on_project_id"

  create_table "energy_consumptions", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "amee_profile_item_id"
    t.string   "energy_consumption_type"
    t.float    "carbon_output_cache"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "energy_consumptions", ["project_id"], :name => "index_energy_consumptions_on_project_id"

  create_table "materials", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "amee_profile_item_id"
    t.string   "material_type"
    t.float    "carbon_output_cache"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "materials", ["project_id"], :name => "index_materials_on_project_id"

  create_table "passwords", :force => true do |t|
    t.integer  "user_id"
    t.string   "reset_code"
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.integer  "client_id"
    t.string   "name"
    t.string   "number"
    t.string   "value"
    t.integer  "floor_area"
    t.string   "amee_profile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["client_id"], :name => "index_projects_on_client_id"

  create_table "roles", :force => true do |t|
    t.integer  "user_id"
    t.string   "role_type"
    t.string   "allowable_id"
    t.string   "allowable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["allowable_id", "allowable_type"], :name => "index_roles_on_allowable_id_and_allowable_type"
  add_index "roles", ["user_id"], :name => "index_roles_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "wastes", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "amee_profile_item_id"
    t.string   "waste_type"
    t.float    "carbon_output_cache"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "waste_method"
  end

  add_index "wastes", ["project_id"], :name => "index_wastes_on_project_id"

end
