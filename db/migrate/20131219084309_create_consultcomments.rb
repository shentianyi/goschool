class CreateConsultcomments < ActiveRecord::Migration
  def change
    create_table :consultcomments do |t|
      t.string :comment
      t.datetime :comment_time
      t.references :logininfo
      t.references :consultation
      t.timestamps
    end

    add_index :consultcomments, :logininfo_id
    add_index :consultcomments, :consultation_id
  end
end
