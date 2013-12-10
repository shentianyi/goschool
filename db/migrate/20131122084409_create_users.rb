class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :image_url
      t.references :logininfo
      t.references :tenant
      t.timestamps
    end
    add_index :users,:logininfo_id
    add_index :users,:tenant_id
  end
end
