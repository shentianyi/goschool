class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :name
      t.string :address
      t.string :tel
      t.references :tenant

      t.timestamps
    end
    add_index :institutions, :tenant_id
  end
end
