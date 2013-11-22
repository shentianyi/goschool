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

<<<<<<< HEAD
ActiveRecord::Schema.define(:version => 20131122081418) do

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
=======
ActiveRecord::Schema.define(:version => 20131122060711) do

  create_table "institutions", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "tel"
    t.integer  "tenant_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "institutions", ["tenant_id"], :name => "index_institutions_on_tenant_id"

  create_table "settings", :force => true do |t|
    t.string   "default_pwd"
    t.integer  "tenant_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "settings", ["tenant_id"], :name => "index_settings_on_tenant_id"

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
>>>>>>> 9753518252cb97bdc0401d4f54bbd0963219cfc8

end
