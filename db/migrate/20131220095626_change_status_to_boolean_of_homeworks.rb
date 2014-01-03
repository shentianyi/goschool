class ChangeStatusToBooleanOfHomeworks < ActiveRecord::Migration
  def change
    change_column :homeworks,:status,:boolean,:default=>false
  end
end
