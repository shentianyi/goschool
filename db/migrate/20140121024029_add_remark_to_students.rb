class AddRemarkToStudents < ActiveRecord::Migration
  def change
    add_column :students, :remark ,:string
  end
end
