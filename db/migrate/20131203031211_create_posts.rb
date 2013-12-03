class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :course
      t.string :content
      t.references :logininfo
      t.references :posttype
      t.references :tenant
      t.string :status
      t.timestamps
    end
    add_index :posts, :course_id
    add_index :posts, :logininfo_id
    add_index :posts, :posttype_id
    add_index :posts, :tenant_id
  end
end
