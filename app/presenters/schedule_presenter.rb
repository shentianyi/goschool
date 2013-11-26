#encoding: utf-8
class SchedulePresenter<Presenter
    def initialize(schedule)
	    @schedule=schedule
	    @course=@schedule.sub_course
	    @teachers=@course.teachers
    end

    def teachers
	    if @teachers.count>0
	      t=[]
	    @teachers.each do |teacher|
	      t<<teacher.name
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
end
