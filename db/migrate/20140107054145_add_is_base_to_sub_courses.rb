class AddIsBaseToSubCourses < ActiveRecord::Migration
  def change
      add_column :sub_courses,:is_base,:boolean,:default=>false
  end
end
