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

  test "should show schedule" do
    get :show, id: @schedule
    assert_response :success
    puts response.body
  end

  test "should update schedule" do
    put :update, id: schedules(:three).id, schedule: { end_time: '2013-11-26 17:48:31', start_time: '2013-11-26 12:43:31' }
    puts response.body
  end

  test "should destroy schedule" do
    assert_difference('Schedule.count', -1) do
      delete :destroy, id: @schedule
      puts response.body
    end
  end

  test 'should get schedules by date' do
      get :dates,{start_date:'2013-11-26',end_date:'2013-11-30'}
      assert_response :success
      puts response.body
  end 
 
  test 'should get schedules by course or sub_course' do
      # get :courses,{type:'Course',id:courses(:one).id}
      # assert_response :success
      # puts response.body
    
      get :courses,{type:'SubCourse',id:sub_courses(:one).id}
      assert_response :success
      puts response.body
  end
end
