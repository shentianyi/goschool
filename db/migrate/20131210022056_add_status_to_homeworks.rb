class AddStatusToHomeworks < ActiveRecord::Migration
  def change
    add_column :homeworks,:status,:integer,:default=>HomeworkStatus::UNFINISHED
  end
end
