class AddTenantReferenceToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules,:tenant_id,:integer
    add_index :schedules, :tenant_id
  end
end
