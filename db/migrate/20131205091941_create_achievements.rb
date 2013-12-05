class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.integer :type
      t.string :achievementstring

      t.timestamps
    end
  end
end
