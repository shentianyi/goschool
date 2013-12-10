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

ActiveRecord::Schema.define(:version => 20131210042900) do

  create_table "achievements", :force => true do |t|
    t.integer  "type"
    t.string   "achievementstring"
    t.integer  "student_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "achievements", ["student_id"], :name => "index_achievements_on_student_id"

  create_table "attachments", :force => true do |t|
    t.string   "name"
    t.string   "path"
    t.string   "size"
    t.string   "type"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "attachments", ["attachable_id"], :name => "index_attachments_on_attachable_id"
  add_index "attachments", ["attachable_type"], :name => "index_attachments_on_attachable_type"

  create_table "comments", :force => true do |t|
    t.integer  "post_id"
    t.boolean  "is_teacher"
    t.integer  "logininfo_id"
    t.string   "content"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "consultations", :force => true do |t|
    t.integer  "student_id"
    t.integer  "logininfo_id"
    t.string   "consultants"
    t.datetime "consult_time"
    t.string   "content"
    t.string   "comment"
    t.datetime "comment_time"
    t.string   "commenter"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "consultations", ["logininfo_id"], :name => "index_consultations_on_logininfo_id"
  add_index "consultations", ["student_id"], :name => "index_consultations_on_student_id"

  create_table "courses", :force => true do |t|
    t.integer  "type",           :default => 100
    t.string   "name"
    t.string   "description"
    t.integer  "lesson",         :default => 0
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "expect_number",  :default => 0
    t.integer  "actual_number",  :default => 0
    t.boolean  "has_sub",        :default => false
    t.integer  "status",         :default => 1
    t.string   "parent_name"
    t.integer  "user_id"
    t.integer  "tenant_id"
    t.integer  "institution_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "code"
  end

  add_index "courses", ["institution_id"], :name => "index_courses_on_institution_id"
  add_index "courses", ["tenant_id"], :name => "index_courses_on_tenant_id"
  add_index "courses", ["user_id"], :name => "index_courses_on_user_id"

  create_table "homeworks", :force => true do |t|
    t.string   "title"
    t.datetime "deadline"
    t.string   "content"
    t.integer  "teacher_course_id"
    t.integer  "unmark_number"
    t.integer  "tenant_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "status",            :default => 1
  end

  add_index "homeworks", ["teacher_course_id"], :name => "index_homeworks_on_teacher_course_id"
  add_index "homeworks", ["tenant_id"], :name => "index_homeworks_on_tenant_id"

  create_table "institutions", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "tel"
    t.integer  "tenant_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "institutions", ["tenant_id"], :name => "index_institutions_on_tenant_id"

  create_table "logininfo_institutions", :force => true do |t|
    t.integer  "institution_id"
    t.integer  "logininfo_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "logininfo_institutions", ["institution_id"], :name => "index_logininfo_institutions_on_institution_id"
  add_index "logininfo_institutions", ["logininfo_id"], :name => "index_logininfo_institutions_on_logininfo_id"

  create_table "logininfo_roles", :force => true do |t|
    t.integer  "role_id"
    t.integer  "logininfo_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "logininfo_roles", ["logininfo_id"], :name => "index_logininfo_roles_on_logininfo_id"

  create_table "logininfos", :force => true do |t|
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "status",              :default => 1
    t.boolean  "is_tenant",           :default => false
    t.integer  "tenant_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "logininfos", ["tenant_id"], :name => "index_logininfos_on_tenant_id"

  create_table "posts", :force => true do |t|
    t.integer  "course_id"
    t.string   "content"
    t.integer  "logininfo_id"
    t.integer  "posttype_id"
    t.integer  "tenant_id"
    t.string   "status"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "posts", ["course_id"], :name => "index_posts_on_course_id"
  add_index "posts", ["logininfo_id"], :name => "index_posts_on_logininfo_id"
  add_index "posts", ["posttype_id"], :name => "index_posts_on_posttype_id"
  add_index "posts", ["tenant_id"], :name => "index_posts_on_tenant_id"

  create_table "posttypes", :force => true do |t|
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rec_results", :force => true do |t|
    t.string   "tenant_id"
    t.string   "entity_type_id"
    t.string   "rec_target_id"
    t.string   "reced_id"
    t.integer  "score"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "rec_results", ["tenant_id", "entity_type_id", "rec_target_id", "reced_id"], :name => "rec_result_unique_index_with_four", :unique => true
  add_index "rec_results", ["tenant_id", "entity_type_id", "rec_target_id"], :name => "rec_result_index_with_three"

  create_table "roles", :force => true do |t|
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "schedules", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "sub_course_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "schedules", ["sub_course_id"], :name => "index_schedules_on_sub_course_id"

  create_table "settings", :force => true do |t|
    t.string   "default_pwd"
    t.integer  "tenant_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "settings", ["tenant_id"], :name => "index_settings_on_tenant_id"

  create_table "student_courses", :force => true do |t|
    t.integer  "student_id"
    t.integer  "course_id"
    t.integer  "tenant_id"
    t.boolean  "paid",       :default => false
    t.integer  "status"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "student_courses", ["course_id"], :name => "index_student_courses_on_course_id"
  add_index "student_courses", ["student_id"], :name => "index_student_courses_on_student_id"
  add_index "student_courses", ["tenant_id"], :name => "index_student_courses_on_tenant_id"

  create_table "student_homeworks", :force => true do |t|
    t.float    "score"
    t.string   "content"
    t.boolean  "improved"
    t.boolean  "marked"
    t.datetime "marked_time"
    t.datetime "submited_time"
    t.integer  "student_id"
    t.integer  "homework_id"
    t.integer  "tenant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "student_homeworks", ["homework_id"], :name => "index_student_homeworks_on_homework_id"
  add_index "student_homeworks", ["student_id"], :name => "index_student_homeworks_on_student_id"
  add_index "student_homeworks", ["tenant_id"], :name => "index_student_homeworks_on_tenant_id"

  create_table "students", :force => true do |t|
    t.string   "name"
    t.integer  "gender"
    t.datetime "birthday"
    t.string   "school"
    t.datetime "graduation"
    t.string   "email"
    t.string   "phone"
    t.string   "address"
    t.string   "guardian"
    t.string   "guardian_phone"
    t.string   "image_url"
    t.integer  "student_status", :default => 0
    t.integer  "logininfo_id"
    t.integer  "referrer_id"
    t.integer  "tenant_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "course_number",  :default => 0
  end

  add_index "students", ["logininfo_id"], :name => "index_students_on_logininfo_id"
  add_index "students", ["referrer_id"], :name => "index_students_on_referrer_id"
  add_index "students", ["tenant_id"], :name => "index_students_on_tenant_id"

  create_table "sub_courses", :force => true do |t|
    t.string   "name"
    t.string   "parent_name"
    t.boolean  "is_default",     :default => false
    t.integer  "course_id"
    t.integer  "tenant_id"
    t.integer  "institution_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "status",         :default => 1
  end

  add_index "sub_courses", ["course_id"], :name => "index_sub_courses_on_course_id"
  add_index "sub_courses", ["institution_id"], :name => "index_sub_courses_on_institution_id"
  add_index "sub_courses", ["tenant_id"], :name => "index_sub_courses_on_tenant_id"

  create_table "tag_counts", :force => true do |t|
    t.string   "tag"
    t.integer  "count"
    t.string   "tenant_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tag_counts", ["tenant_id", "tag"], :name => "index_tag_counts_on_tenant_id_and_tag", :unique => true
  add_index "tag_counts", ["tenant_id"], :name => "index_tag_counts_on_tenant_id"

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

  create_table "teacher_courses", :force => true do |t|
    t.integer  "sub_course_id"
    t.integer  "user_id"
    t.integer  "tenant_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "teacher_courses", ["sub_course_id"], :name => "index_teacher_courses_on_sub_course_id"
  add_index "teacher_courses", ["tenant_id"], :name => "index_teacher_courses_on_tenant_id"
  add_index "teacher_courses", ["user_id"], :name => "index_teacher_courses_on_user_id"

  create_table "tenants", :force => true do |t|
    t.string   "company_name"
    t.integer  "edition"
    t.integer  "subscription_status"
    t.string   "access_key"
    t.string   "domain"
    t.integer  "logininfo_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "tenants", ["logininfo_id"], :name => "index_tenants_on_logininfo_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "image_url"
    t.integer  "logininfo_id"
    t.integer  "tenant_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "is_teacher",   :default => false
  end

  add_index "users", ["logininfo_id"], :name => "index_users_on_logininfo_id"
  add_index "users", ["tenant_id"], :name => "index_users_on_tenant_id"

end
