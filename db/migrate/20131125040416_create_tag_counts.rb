class CreateTagCounts < ActiveRecord::Migration
  def change
    create_table :tag_counts do |t|
      t.string :tag
      t.integer :count
      t.string :tenant_id

      t.timestamps
    end
  end
end
