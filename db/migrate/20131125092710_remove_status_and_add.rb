class RemoveStatusAndAdd < ActiveRecord::Migration
  def up
  end

  def change
    remove_column :users, :status
    add_column :logininfos, :status, :integer, :default=>1
  end

  def down
  end
end
