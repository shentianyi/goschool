class AddAchievetimeToAchievementresults < ActiveRecord::Migration
  def change
    add_column :achievementresults, :achievetime, :datetime
  end
end
