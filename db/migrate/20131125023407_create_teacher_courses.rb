class CreateTeacherCourses < ActiveRecord::Migration
  def change
    create_table :teacher_courses do |t|
      t.references :sub_course
      t.references :user
      t.references :tenant
      t.timestamps
    end
    add_index :teacher_courses, :sub_course_id
    add_index :teacher_courses, :user_id
    add_index :teacher_courses, :tenant_id
  end
end
