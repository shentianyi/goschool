class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.references :logininfo
      t.timestamps
    end
    add_index :users,:logininfo_id
  end
end