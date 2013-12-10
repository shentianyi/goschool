class Attachment < ActiveRecord::Base
  # attr_accessible :title, :body
  self.inheritance_column = nil
  belongs_to :attachable, :polymorphic=>true
  attr_accessible :name, :path, :size, :type, :attachable_id, :attachable_type
  
  # this method can be used to add attachemts
  def self.add attachments,attachable
    # attachments.each do |att|
      # path=File.join($AttachPath,att[:path_name])
      # FileUtils.mv(File.join($AttachTmpPath,att[:path_name]),path)
      # attachable.attachments<<self.new(name:att[:ori_name],path:path,size:FileData.get_size(path),type:FileData.get_type(path))
    # end
  end
  
end
