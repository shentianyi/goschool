require 'test_helper'

class LogininfosControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  setup do
    @logininfo = logininfos(:one)
  end

  test "should update logininfo" do
    puts :update, id:@logininfo, logininfo:{email:'test@test.com',user:{email:'test@test.com',name:@logininfo.user.name}}
  end
end
