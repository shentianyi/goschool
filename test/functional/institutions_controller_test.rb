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

  test "show destroy institution" do
    assert_difference("Institution.count",-1) do
      delete :destroy , :id=>@institution.id
    end
    puts response.body
  end

  private

  def  initialize_institution
    @institution=institutions(:one)
  end
end
