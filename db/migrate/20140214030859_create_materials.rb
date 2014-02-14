class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :name
      t.string :description
      t.integer :status
      t.references :materialable, :polymorphic=>true
      t.references :material

      t.timestamps
    end
    add_index :materials, :materialable_id
    add_index :materials, :material_id
    add_index :materials, :materialable_type
  end
end
