class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :sub_course

      t.timestamps
    end
    add_index :schedules, :sub_course_id
  end
end
