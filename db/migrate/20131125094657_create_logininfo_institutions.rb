class CreateLogininfoInstitutions < ActiveRecord::Migration
  def change
    create_table :logininfo_institutions do |t|
      t.references :institution
      t.references :logininfo
      t.timestamps
    end
    add_index :logininfo_institutions, :institution_id
    add_index :logininfo_institutions, :logininfo_id
  end
end
