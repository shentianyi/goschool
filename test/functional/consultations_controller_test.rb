# -*- coding: utf-8 -*-
require 'test_helper'

class ConsultationsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do 
    @student = students(:one)
    @logininfo = logininfos(:one)
  end

  test "should create Consultation" do
    assert_difference('Consultation.count') do
      post :create, id:@student,
      consultation: {student_id:@student,logininfo_id:@logininfo,consultants:'李女士',consult_time:'2013-12-05',content:'询问了开课时间'}
    end

    #assert_redirected_to consultation_path(assigns(:consultation))
  end
end
