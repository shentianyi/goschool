class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.references :role
      t.references :logininfo
      t.timestamps
    end
    add_index :user_roles ,:role_id
    add_index :user_roles ,:logininfo_id
  end
end
