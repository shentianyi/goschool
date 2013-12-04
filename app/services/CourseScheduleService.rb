#encoding: utf-8
class CourseScheduleService
 def generate_employee_schedule_by_institution institution_id
   if Schedule.count_by_institution_id(institution_id)>0
     emails=User.get_employees(institution_id).collect{|user| user.email}
     schedules=Schedule.by_insititution_id(institution_id)
   end
 end
end
