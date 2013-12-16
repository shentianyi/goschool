class CreatePosttypes < ActiveRecord::Migration
  def change
    create_table :posttypes do |t|
      t.string :value
      t.timestamps
    end
  end
end
