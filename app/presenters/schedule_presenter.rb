#encoding: utf-8
class SchedulePresenter<Presenter
  def_delegators :@schedule,:name,:parent_name,:id,:start_time,:end_time,:teachers
  def initialize(schedule)
    @schedule=schedule
  end

  def teachers
    self.teachers
  end
  
  def start_hour
   '%02d' % self.start_time.hour
  end
  
  def end_hour
     '%02d' % self.end_time.hour
  end
  
  def start_date
    self.start_time.strftime('%Y%m%d')
  end
  
  
  def end_date
    self.end_time.strftime('%Y%m%d')
  end
  
  def time
    "#{start_date}  #{start_time}-#{end_time}"
  end
  
  def teacher_names
      teachers.map{|t| t.name}
    end
    
    def teacher_names_string
      teacher_names.join(', ')
    end

  def to_json
    {course_name:self.parent_name,
      sub_course_name:self.name,
      start_time:self.start_time,
      end_time:self.end_time,
      teachers:self.teachers.collect{|teacher| {id:teacher.id,name:teacher.name}}
    }
  end

end
