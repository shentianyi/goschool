class CreateHomeWorks < ActiveRecord::Migration
  def change
    create_table :home_works do |t|
      t.string :title
      t.datetime :deadline
      t.string :content
      t.integer :unmark_number ,:default=>0
      t.references :teacher_course

      t.timestamps
    end
    add_index :home_works, :teacher_course_id
  end
end
