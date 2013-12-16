class CreateTenants < ActiveRecord::Migration
  def change
    create_table :tenants do |t|
      t.string :company_name
      t.integer :edition
      t.integer :subscription_status
      t.string :access_key
      t.string :domain
      t.references :logininfo
      t.timestamps
    end
     add_index :tenants, :logininfo_id
  end
end
