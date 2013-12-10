class AddStatusToHomeworks < ActiveRecord::Migration
  def change
    add_column :homeworks,:status,:integer,:default=>HomeworkStatus::UNGOING
  end
end
