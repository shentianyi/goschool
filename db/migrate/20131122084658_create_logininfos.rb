class CreateLogininfos < ActiveRecord::Migration
  def change
    create_table :logininfos do |t|
      t.string :email, :null=>fale
      t.string :crypted_password, :null=>false
      t.string :password_salt, :null=>false
      t.string :persistence_token, :null=>false
      t.string :single_access_token,:null=>false
      t.string :perishable_token,:null=>false
      t.integer :login_count,:null=>false
      t.integet :failed_login_count,:null=>false
      t.datetime :last_request_at 
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip
      t.integet :is_tenant
      t.references :tenant
      t.timestamps
    end
    add_index :logininfos, :tenant_id
  end
end
