#encoding: utf-8
class CoursePresenter<Presenter
    def_delegators :@course,:id,:name,:description,:actual_number,:expect_number,:lesson,:type,:code,:start_date,:end_date,:tenant_id,:status,:teachers,:institution_name,:course_teachers,:course_students

    def initialize(course)
     @course=course
    end
    
    def tags
      TagUtility.new.get_tags(self.tenant_id,@course.class.name,self.id)
    end
    
    def status_display
      CourseStatus.display self.status
    end
     
     def type_display
       CourseType.display self.type
     end

    def teacher_names
      teachers.uniq.map{|t| t.name}
    end
    
    def teacher_names_string
      teacher_names.join(', ')
    end

end