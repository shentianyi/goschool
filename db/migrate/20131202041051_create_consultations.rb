class CreateConsultations < ActiveRecord::Migration
  def change
    create_table :consultations do |t|
      t.references :student
      t.references :logininfo
      t.string :consultants
      t.datetime :consult_time
      t.string :content
      t.string :comment
      t.datetime :comment_time
      t.string :commenter
      t.timestamps
    end
    add_index :consultations, :student_id
    add_index :consultations, :logininfo_id
  end
end
