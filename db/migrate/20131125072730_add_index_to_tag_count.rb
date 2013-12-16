class AddIndexToTagCount < ActiveRecord::Migration
  def change
    add_index :tag_counts,:tenant_id
    add_index :tag_counts,[:tenant_id,:tag],:unique=>true
  end
end
