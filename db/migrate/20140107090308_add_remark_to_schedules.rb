class AddRemarkToSchedules < ActiveRecord::Migration
  def change
add_column :schedules,:remark,:string
  end
end
