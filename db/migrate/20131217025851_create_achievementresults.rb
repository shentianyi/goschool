class CreateAchievementresults < ActiveRecord::Migration
  def change
    create_table :achievementresults do |t|
      t.string :valuestring
      t.references :achievement
      t.references :student
      t.timestamps
    end
    add_index :achievementresults, :student_id
    add_index :achievementresults, :achievement_id
  end
end
