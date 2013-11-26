#encoding: utf-8
class Institution < ActiveRecord::Base
  belongs_to :tenant
  has_many :courses,:dependent=>:destroy
  attr_accessible :address, :name, :tel
  acts_as_tenant(:tenant)

  validate :validate_save
  private
  def validate_save
    errors.add(:name,'机构名称不可为空') if self.name.blank?
    errors.add(:name,'机构名称不可重复') if self.class.where(:name=>self.name).first if new_record?
    errors.add(:name,'机构名称不可重复') if self.class.where('id<>? and name=?',self.id,self.name).first unless new_record?
  end
end
