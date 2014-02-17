class AddEditableToMaterial < ActiveRecord::Migration
  def change
    add_column :materials, :editable, :boolean, :default=>false
  end
end
