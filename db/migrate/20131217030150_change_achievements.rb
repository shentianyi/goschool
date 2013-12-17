class ChangeAchievements < ActiveRecord::Migration
  def up
  end

  def down
  end

  def change
    add_column :achievements, :parent_id, :integer, :default=>0
    add_column :achievements, :name, :string
    remove_column :achievements, :student_id
    remove_column :achievements, :achievementstring
  end
end
