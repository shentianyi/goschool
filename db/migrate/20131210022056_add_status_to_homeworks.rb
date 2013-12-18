class AddStatusToHomeworks < ActiveRecord::Migration
  def change
    add_column :homeworks,:status,:integer,:default=>HomeworkStatus::UNMARK
  end
end
