class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.integer :gender
      t.datetime :birthday
      t.string :school
      t.datetime :graduation
      t.string :email
      t.string :phone
      t.string :address
      t.string :guardian
      t.string :guardian_phone
      t.string :image_url
      t.references :logininfo
      t.integer :referrer_id
      t.timestamps
    end
    add_index :students, :logininfo_id
    add_index :students, :referrer_id
  end
end