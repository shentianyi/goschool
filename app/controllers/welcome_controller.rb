#encoding: utf-8
class WelcomeController < ApplicationController
	skip_authorize_resource
	skip_before_filter :require_user_as_employee

	def index
		switch current_logininfo
	end

	def switch user
		if user.is_employee?
      		redirect_to students_path
    	elsif user.is_student?
      		redirect_to student_index_path
    	elsif user.is_teacher?
      		redirect_to teachers_index_path
    	end
	end	
end
