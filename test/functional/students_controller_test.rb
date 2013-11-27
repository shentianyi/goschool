require 'test_helper'

class StudentsControllerTest < ActionController::TestCase
  setup do
    @student = students(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:students)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create Student" do
    assert_difference('Student.count') do
<<<<<<< HEAD
      post :create, Student: { address: @student.address, birthday: @student.birthday, email: @student.email, gender: @student.gender, graduation: @student.graduation, guardian: @student.guardian, guardian_phone: @student.guardian_phone, name: @student.name, phone: @student.phone, school: @student.school }
=======
      post :create, student: { address: @student.address, birthday: @student.birthday, email: @student.email, gender: @student.gender, graduation: @student.graduation, guardian: @student.guardian, guardian_phone: @student.guardian_phone, name: @student.name, phone: @student.phone, school: @student.school ,tenant_id: @student.tenant.id, logininfo_id: @student.logininfo.id, referrer_id: @student.referrer.id}
>>>>>>> 4c015cb2e3d8db5f1e9bc8be033835ff382e4066
    end

    assert_redirected_to student_path(assigns(:Student))
  end

  test "should show Student" do
    get :show, id: @student
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @student
    assert_response :success
  end

  test "should update Student" do
    put :update, id: @student, Student: { address: @student.address, birthday: @student.birthday, email: @student.email, gender: @student.gender, graduation: @student.graduation, guardian: @student.guardian, guardian_phone: @student.guardian_phone, name: @student.name, phone: @student.phone, school: @student.school }
    #assert_redirected_to student_path(assigns(:Student))
  end

  test "should destroy Student" do
    assert_difference('Student.count', -1) do
      delete :destroy, id: @student
    end

    assert_redirected_to students_path
  end

  test "should list search students" do
    get :list_search ,query:'M'
    assert_response :success
    puts response.body
  end
end
