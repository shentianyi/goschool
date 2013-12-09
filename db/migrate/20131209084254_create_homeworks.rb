class CreateHomeworks < ActiveRecord::Migration
  def change
    create_table :homeworks do |t|
      t.string :title
      t.datetime :deadline
      t.string :content
      t.references :teacher_course
      t.integer :unmark_number

      t.timestamps
    end
    add_index :homeworks, :teacher_course_id
  end
end
