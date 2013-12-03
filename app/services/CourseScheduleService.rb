#encoding: utf-8
class CourseScheduleService
 def get_employee_schedule_by_institution institution_id
   emails=User.get_employees(institution_id).all.collect{|user| user.email}
 end
end
