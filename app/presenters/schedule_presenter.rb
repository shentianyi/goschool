#encoding: utf-8
class SchedulePresenter<Presenter
    def initialize(schedule,course=nil,teachers=nil)
	  unless schedule.is_a?(Array)
	    @schedule=schedule
	    @course=course||@schedule.sub_course
	    @teachers=teachers||@course.teachers.all
	  else
	    @schedules=schedule
	  end
    end

    def teachers
	    if @teachers.count>0
	      t=[]
	    @teachers.each do |teacher|
	      t<<{name:teacher.name,id:teacher.id}
	    end 
	    end
	    t
    end
    
    def to_json
      {course_name:@course.parent_name,
        sub_course_name:@course.name,
        start_time:@schedule.start_time,
        end_time:@schedule.end_time,
        teachers:teachers}
    end
    
    def to_jsons
       courses={}
       teachers={}
       jsons=[]
       @schedules.each do |schedule|
      unless courses[schedule.sub_course_id]
          courses[schedule.sub_course_id]=schedule.sub_course 
            teachers[schedule.sub_course_id]= courses[schedule.sub_course_id].teachers.all
      end
         jsons<<SchedulePresenter.new(schedule,courses[schedule.sub_course_id],teachers[schedule.sub_course_id]).to_json
       end if @schedules
       return jsons
    end
end
