class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :type
      t.string :name
      t.string :description
      t.integer :lesson,:default=>0
      t.date :start_date
      t.date :end_date
      t.integer :expect_number,:default=>0
      t.integer :actual_number,:default=>0
      t.boolean :has_sub,:default=>false
      t.integer :status,:default=>CourseStatus::UNLOCK
      t.string :parent_name
      t.references :user
      t.references :tenant
      t.references :institution
      t.timestamps
    end
    add_index :courses, :user_id
    add_index :courses, :tenant_id
    add_index :courses, :institution_id
  end
end
