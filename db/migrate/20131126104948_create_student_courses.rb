class CreateStudentCourses < ActiveRecord::Migration
  def change
    create_table :student_courses do |t|
      t.references :Student
      t.references :course
      t.boolean :paid,:default=>false
      t.integer :status
      t.references :tenant
      t.timestamps
    end
    add_index :student_courses, :student_id
    add_index :student_courses, :course_id
    add_index :student_courses, :tenant_id
  end
end
