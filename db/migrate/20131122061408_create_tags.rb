class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :tenant_id
      t.string :entity_type_id
      t.string :entity_id
      t.string :tag

      t.timestamps
    end
  end
end
