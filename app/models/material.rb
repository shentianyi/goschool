#encoding: utf-8
class Material < ActiveRecord::Base
  belongs_to :materialable, :polymorphic => true
  belongs_to :material
  belongs_to :logininfo
  has_many :materials, :dependent => :delete_all

  attr_accessible :description, :name, :status, :materialable_type
  acts_as_tenant(:tenant)

  validate :validate_save
  private
  def validate_save
    errors.add(:name, '材料名称不可为空') if self.name.blank? && (self.materialable.is_a?(Setting) || self.materialable.is_a?(Course))
  end


  def after_create_
    puts '*****************************'
    puts self.materialable.is_a?(Course)
    puts self.materialable.class

    if self.materialable.is_a?(Course)
      self.materialable.student_courses.each do |student_course|
        #student_course.material.create
        m=student_course.materials.build
        m.material=material
        m.save
      end
    end
  end
end
