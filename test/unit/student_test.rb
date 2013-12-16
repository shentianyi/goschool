require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should get student courses" do
    courses=Student.course_detail(students(:one).id).all
 
    puts courses.class
  end
end
