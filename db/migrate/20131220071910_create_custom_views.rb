class CreateCustomViews < ActiveRecord::Migration
  def change
    create_table :custom_views do |t|
      t.integer :user_id
      t.string :name
      t.string :query_type
      t.string :entity_type
      t.string :query
      t.timestamps
    end
  end
end
