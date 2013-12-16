class CreateLogininfoRoles < ActiveRecord::Migration
  def change
    create_table :logininfo_roles do |t|
      #role_id
      t.integer :role_id
      #logininfo_id
      t.references :logininfo
      t.timestamps
    end
    add_index :logininfo_roles, :logininfo_id
  end
end
