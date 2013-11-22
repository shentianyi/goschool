#encoding: utf-8
class Cource < ActiveRecord::Base
  belongs_to :user
  belongs_to :tenant
  belongs_to :institution
  attr_accessible :actual_number, :description, :end_date, :expect_number, :lesson, :name, :start_date, :sub_number, :type
  attr_accessible :institution_id
  acts_as_tenant(:tenant)
end
