class RecreateLogininfo < ActiveRecord::Migration
  def up
  end
  def change
    drop_table :logininfos if self.table_exists?("logininfos")

    #create table
    create_table :logininfos do |t|
      t.string :email, :null=>false
      t.string :crypted_password, :null=>false
      t.string :password_salt, :null=>false
      t.string :persistence_token, :null=>false
      t.string :single_access_token,:null=>false
      t.string :perishable_token,:null=>false
      t.integer :login_count,:null=>false ,:default=>0
      t.integer :failed_login_count,:null=>false ,:default=>0
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip
      t.integer :status,:default=>1
      t.boolean :is_tenant,:default=>false
      t.references :tenant
      t.timestamps
    end
    add_index :logininfos, :tenant_id
  end
  def down
  end
end
