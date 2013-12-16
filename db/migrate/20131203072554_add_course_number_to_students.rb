class AddCourseNumberToStudents < ActiveRecord::Migration
  def change
      add_column :students,:course_number,:integer,:default=>0
  end
end
