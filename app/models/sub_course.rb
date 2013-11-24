class SubCourse < ActiveRecord::Base
  belongs_to :course
  attr_accessible :name, :parent_name
end
