#encoding: utf-8
class Course < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  belongs_to :user
  belongs_to :tenant
  belongs_to :institution
  has_many :sub_courses,:dependent=>:destroy
  attr_accessible :actual_number, :description, :end_date, :expect_number, :lesson, :name, :start_date, :sub_number, :type
  attr_accessible :institution_id
  acts_as_tenant(:tenant)

  validate :validate_save
  private
  def validate_save
    errors.add(:name,'课程名称不可为空') if self.name.blank?
  end
end
