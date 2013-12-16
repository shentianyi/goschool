class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :post
      t.boolean :is_teacher
      t.references :logininfo
      t.string :content
      t.timestamps
    end
  end
end
