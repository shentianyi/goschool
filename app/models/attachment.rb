class Attachment < ActiveRecord::Base
  # attr_accessible :title, :body
  self.inheritance_column = nil
  belongs_to :attachable, :polymorphic=>true
  attr_accessible :name, :path, :size, :type, :attachable_id, :attachable_type
end
