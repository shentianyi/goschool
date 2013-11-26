class CreateStudentCourses < ActiveRecord::Migration
  def change
    create_table :student_courses do |t|
      t.references :student
      t.references :course
      t.boolean :paid
      t.integer :status

      t.timestamps
    end
    add_index :student_courses, :student_id
    add_index :student_courses, :course_id
  end
end
