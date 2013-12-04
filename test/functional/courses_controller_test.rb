require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = true

  setup do
    @course = courses(:one)
  end
  
  test "should create course" do
    assert_difference('Course.count') do
      post :create,
      course: {
        description: "gaming TUOFU",
        end_date: "2013-11-11",
        expect_number: 100,
        lesson:24,
        name:  "courseEat",
        start_date:  "2013-11-01",
        type: 0,
        subs:[{name:'Game',teachers:[{teacher_id:users(:one).id},{teacher_id:users(:one).id}]},{name:'Read'}],
        tags:['TUOFU','Game'] }
      assert_response :success
      puts response.body
    end
  end

  test "should get edit" do
    get :edit, id: @course.id
    assert_response :success
    puts response.body
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete :destroy, id: @course
    end
  end

  test 'should list  search course' do
    get :list_search ,q:'c'
    assert_response :success
    puts response.body
  end
 
  test 'should show' do
    get :show ,id:@course.id,part:'students'
    assert_response :success
    puts response.body
  end
end
