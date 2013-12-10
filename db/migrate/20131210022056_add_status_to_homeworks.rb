class AddStatusToHomeworks < ActiveRecord::Migration
  def change
    add_column :homeworks,:status,:integer,:default=>HomeworkStatus::UNLOCK
  end
end
