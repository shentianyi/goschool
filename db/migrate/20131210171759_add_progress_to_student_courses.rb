class AddProgressToStudentCourses < ActiveRecord::Migration
  def change
    add_column :student_courses,:progress,:string
  end
end
