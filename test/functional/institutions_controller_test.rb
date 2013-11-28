require 'test_helper'

class InstitutionsControllerTest < ActionController::TestCase
  setup :initialize_institution
  def teardown
    @institution=nil
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test "should show institution" do
    get :show,:id=>@institution.id
    assert_response :success
  end

  test "should create institution" do
    assert_difference('Institution.count') do
      post :create, :institution=> { :name=>@institution.name}
      puts response.body
    end

  end

  test "should update institution" do
    put :update,:id=>@institution.id, :institution=> { :name=>''}
    assert_response :success
    puts response.body
  end

  test "show destroy institution" do
    assert_difference("Institution.count",-1) do
      delete :destroy , :id=>@institution.id
      assert_response :success
      puts response.body
    end
  end

  private

  def  initialize_institution
    @institution=institutions(:one)
  end
end
