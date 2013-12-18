#encoding: utf-8
class StudentHomework < ActiveRecord::Base
  belongs_to :student
  belongs_to :homework
  belongs_to :tenant
  has_many :attachments,:as=>:attachable,:dependent=>:destroy
  attr_accessible :content, :improved, :marked, :marked_time, :score, :submited_time,:homework_id
  acts_as_tenant(:tenant)

  def self.detail_by_homework_id homework_id
   joins(:student).where(homework_id:homework_id).select("students.name, students.id as student_id,student_homeworks.*")
  end
end
