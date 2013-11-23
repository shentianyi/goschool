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

ActiveRecord::Schema.define(:version => 20131122093807) do

  create_table "cources", :force => true do |t|
    t.integer  "type"
    t.string   "name"
    t.string   "description"
    t.integer  "lesson",         :default => 0
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "expect_number",  :default => 0
    t.integer  "actual_number",  :default => 0
    t.integer  "sub_number",     :default => 0
    t.integer  "user_id"
    t.integer  "tenant_id"
    t.integer  "institution_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "cources", ["institution_id"], :name => "index_cources_on_institution_id"
  add_index "cources", ["tenant_id"], :name => "index_cources_on_tenant_id"
  add_index "cources", ["user_id"], :name => "index_cources_on_user_id"

  create_table "institutions", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "tel"
    t.integer  "tenant_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "institutions", ["tenant_id"], :name => "index_institutions_on_tenant_id"

  create_table "logininfos", :force => true do |t|
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",                            :null => false
    t.integer  "failed_login_count",                     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "is_tenant",           :default => false
    t.integer  "tenant_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "logininfos", ["tenant_id"], :name => "index_logininfos_on_tenant_id"

  create_table "roles", :force => true do |t|
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "default_pwd"
    t.integer  "tenant_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "settings", ["tenant_id"], :name => "index_settings_on_tenant_id"

  create_table "tags", :force => true do |t|
    t.string   "tenant_id"
    t.string   "entity_type_id"
    t.string   "entity_id"
    t.string   "tag"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "tags", ["tenant_id", "entity_type_id", "entity_id", "tag"], :name => "index_tags_on_tenant_id_and_entity_type_id_and_entity_id_and_tag", :unique => true
  add_index "tags", ["tenant_id", "entity_type_id", "entity_id"], :name => "index_tags_on_tenant_id_and_entity_type_id_and_entity_id"
  add_index "tags", ["tenant_id", "entity_type_id", "tag"], :name => "index_tags_on_tenant_id_and_entity_type_id_and_tag"
  add_index "tags", ["tenant_id", "tag"], :name => "index_tags_on_tenant_id_and_tag"

  create_table "tenants", :force => true do |t|
    t.string   "company_name"
    t.integer  "edition"
    t.integer  "subscription_status"
    t.string   "access_key"
    t.string   "domain"
    t.integer  "user_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "tenants", ["user_id"], :name => "index_tenants_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "logininfo_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "users", ["logininfo_id"], :name => "index_users_on_logininfo_id"

end
