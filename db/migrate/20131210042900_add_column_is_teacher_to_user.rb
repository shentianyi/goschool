class AddColumnIsTeacherToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_teacher, :boolean, :default=>false
  end
end
