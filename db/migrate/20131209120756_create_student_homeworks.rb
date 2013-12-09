class CreateStudentHomeworks < ActiveRecord::Migration
  def change
    create_table :student_homeworks do |t|
      t.float :score
      t.string :content
      t.boolean :improved
      t.boolean :marked
      t.datetime :marked_time
      t.datetime :submited_time
      t.references :student
      t.references :homework

      t.timestamps
    end
    add_index :student_homeworks, :student_id
    add_index :student_homeworks, :homework_id
  end
end
