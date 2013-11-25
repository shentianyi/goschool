class AddStatusToUser < ActiveRecord::Migration
  def change
    add_column :users,:status,:integer,:default=>1
  end
end
