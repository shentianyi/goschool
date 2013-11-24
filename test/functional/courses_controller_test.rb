require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = true

  setup do
    @course = courses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should create course" do
    assert_difference('Course.count') do
      post :create,
      course: {
        description: "jjj",
        end_date: "2013-11-11",
        expect_number: 100,
        lesson:24,
        name:  "TUOFU",
        start_date:  "2013-11-01",
        type: 0,
        subs:[{name:'Game'},{name:'Read'}],
        tags:['TUOFU','Game'] }
      assert_response :success
      puts response.body
    end
  end

  test "should get edit" do
    get :edit, id: @course.id
    assert_response :success
    # puts response.body
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete :destroy, id: @course
    end
  end
end
