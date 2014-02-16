class ChangeMarkedAndImprovedOfStudentHomeworks < ActiveRecord::Migration
  def change
    change_column :student_homeworks,:marked,:boolean,:default=>false
    change_column :student_homeworks,:improved,:boolean,:default=>true
  end
end
