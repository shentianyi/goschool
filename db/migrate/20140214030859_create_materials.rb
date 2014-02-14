class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :name
      t.string :description
      t.integer :status, :default=>MaterialStatus::DEFAULT
      t.references :materialable, :polymorphic=>true
      t.references :material
      t.references :tenant
      t.references :logininfo
      t.timestamps
    end
    add_index :materials, :materialable_id
    add_index :materials, :material_id
    add_index :materials, :materialable_type
    add_index :materials,:tenant_id
    add_index :materials,:logininfo_id
  end
end
