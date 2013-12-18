class StudentController < ApplicationController
  skip_before_filter :require_user_as_employee
  before_filter :require_user_as_student
  layout 'homepage'
  
  def index
  end
end
