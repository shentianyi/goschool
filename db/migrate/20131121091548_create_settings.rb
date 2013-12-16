class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :default_pwd
      t.references :tenant
      t.timestamps
    end
    add_index :settings, :tenant_id
  end
end
