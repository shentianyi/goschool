class AddStatusToSubCourses < ActiveRecord::Migration
  def change
      add_column :sub_courses,:status,:integer,:default=>CourseStatus::UNLOCK
  end
end
