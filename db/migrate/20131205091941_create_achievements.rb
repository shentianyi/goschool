class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.integer :type
      t.string :achievementstring
      t.references :student
      t.timestamps
    end
    add_index :achievements, :student_id
  end
end
