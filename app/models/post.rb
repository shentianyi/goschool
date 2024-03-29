#encoding: utf-8
class Post < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :course_id, :content, :logininfo_id, :posttype_id, :tenant_id, :title

  belongs_to :course
  belongs_to :logininfo
  belongs_to :posttype
  belongs_to :tenant
  has_many :attachments, :as=>:attachable
  has_many :comments, :dependent=>:destroy

  validate :validate_save

  acts_as_tenant(:tenant)

  def validate_save
    errors.add(:content, '帖子内容不能为空') if self.content.blank?
  end

  def self.by_type params
    where(course_id:params[:id]).where(PostStudentMenuType.condition(params[:menu_type])).order("created_at DESC")
  end
end
