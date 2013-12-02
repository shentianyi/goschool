class CreateSubCourses < ActiveRecord::Migration
  def change
    create_table :sub_courses do |t|
      t.string :name
      t.string :parent_name
      t.boolean :is_default,:default=>false
      t.references :Course
      t.references :tenant
      t.references :institution
      t.timestamps
    end
    add_index :sub_courses, :course_id
    add_index :sub_courses, :tenant_id
    add_index :sub_courses, :institution_id
  end
end
