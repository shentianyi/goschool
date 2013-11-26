class CreateRecResults < ActiveRecord::Migration
  def change
    create_table :rec_results do |t|
      t.string :tenant_id
      t.string :entity_type_id
      t.string :rec_target_id
      t.string :reced_id
      t.integer :score

      t.timestamps
    end
  end
end
