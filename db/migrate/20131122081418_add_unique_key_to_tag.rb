class AddUniqueKeyToTag < ActiveRecord::Migration
  def change
    add_index :tags, [:tenant_id,:entity_type_id,:entity_id,:tag],:unique => true
  end
end
