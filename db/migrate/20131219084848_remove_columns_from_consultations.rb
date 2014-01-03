class RemoveColumnsFromConsultations < ActiveRecord::Migration
  def up
  end

  def change
    remove_column :consultations, :comment
    remove_column :consultations, :comment_time
    remove_column :consultations, :commenter
  end

  def down
  end
end
