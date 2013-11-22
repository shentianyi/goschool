class Cource < ActiveRecord::Base
  belongs_to :user
  attr_accessible :actual_number, :description, :end_date, :expect_number, :lesson, :name, :start_date, :sub_number, :type
end
