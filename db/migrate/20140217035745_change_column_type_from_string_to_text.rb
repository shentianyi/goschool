class ChangeColumnTypeFromStringToText < ActiveRecord::Migration
  def change
    change_column :materials,:description,:text
    change_column :homeworks,:content,:text
  end
end
