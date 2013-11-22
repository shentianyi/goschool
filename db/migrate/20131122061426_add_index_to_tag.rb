class AddIndexToTag < ActiveRecord::Migration
  def change
    add_index :tags, [:tenant_id,:entity_type_id,:entity_id]
    add_index :tags, [:tenant_id,:entity_type_id,:tag]
    add_index :tags, [:tenant_id,:tag]
  end
end
