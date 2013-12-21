class Attachment < ActiveRecord::Base
  # attr_accessible :title, :body
  self.inheritance_column = nil
  belongs_to :attachable, :polymorphic=>true
  attr_accessible :name, :path, :size, :type, :attachable_id, :attachable_type
  
  # this method can be used to add attachemts
  def self.add attachments,attachable
    unless attachments.blank?
      attachments.each do |index,att|
        path = File.join($AttachTmpPath,att[:pathName])
        size = FileData.get_size(path)
        type = FileData.get_type(path)

        data = AttachService.generate_attachment path
        #filename = att[:oriName]

        url = AliyunOssService.store_attachments(att[:pathName],data)
        File.delete(path)
        attachable.attachments<<Attachment.new(:name=>att[:oriName],:path=>url,:size=>size,:type=>type)
      end
    end
  end
  
end
