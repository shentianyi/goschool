class CreateCources < ActiveRecord::Migration
  def change
    create_table :cources do |t|
      t.integer :type
      t.string :name
      t.string :description
      t.integer :lesson,:default=>0
      t.date :start_date
      t.date :end_date
      t.integer :expect_number,:default=>0
      t.integer :actual_number,:default=>0
      t.integer :sub_number,:default=>0
      t.references :user

      t.timestamps
    end
    add_index :cources, :user_id
  end
end
