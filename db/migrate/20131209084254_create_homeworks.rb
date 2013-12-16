class CreateHomeworks < ActiveRecord::Migration
  def change
    create_table :homeworks do |t|
      t.string :title
      t.datetime :deadline
      t.string :content
      t.references :teacher_course
      t.integer :unmark_number
      t.references :tenant
      t.timestamps
    end
    add_index :homeworks, :teacher_course_id
    add_index :homeworks, :tenant_id
  end
end
