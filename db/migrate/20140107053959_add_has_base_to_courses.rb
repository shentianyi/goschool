class AddHasBaseToCourses < ActiveRecord::Migration
  def change
      add_column :courses,:has_base,:boolean,:default=>false
  end
end
