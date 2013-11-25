require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  setup do
    @schedule = schedules(:one)
  end


  test "should create schedule" do
    assert_difference('Schedule.count') do
      post :create, schedule: {sub_course_id:sub_courses(:one) ,end_time: @schedule.end_time, start_time: @schedule.start_time }
      puts response.body
   end

  end

  # test "should show schedule" do
    # get :show, id: @schedule
    # assert_response :success
    # puts response.body
  # end
# 
  # test "should update schedule" do
    # put :update, id: @schedule, schedule: { end_time: @schedule.end_time, start_time: @schedule.start_time }
    # puts response.body
  # end
# 
  # test "should destroy schedule" do
    # assert_difference('Schedule.count', -1) do
      # delete :destroy, id: @schedule
      # puts response.body
    # end
  # end
end
