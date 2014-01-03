class AddPathnameToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :pathname, :string
  end
end
