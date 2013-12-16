#encoding: utf-8
class SchedulePresenter<Presenter
  def_delegators :@schedule,:name,:parent_name,:id,:start_time,:end_time,:is_default,:teachers
  def initialize(schedule)
    @schedule=schedule
  end
  
  
  def start_hour
   '%02d:%02d' % [self.start_time..hour,self.start_time.min]
  end
  
  def end_hour
    '%02d:%02d' % [self.end_time.hour,self.end_time.min]
  end
  
  def start_date
    self.start_time.strftime('%Y-%m-%d')
  end
  
  
  def end_date
    self.end_time.strftime('%Y-%m-%d')
  end
  
  def time_string
    "#{start_date}  #{start_hour}-#{end_hour}"
  end
  
  def teacher_names
      teachers.map{|t| t.name}
    end
    
    def teacher_names_string
      teacher_names.join(', ')
    end

  def to_json
    { text:self.parent_name,
      id:self.id,
      teachers:self.teacher_names,
      start_date:self.start_time.to_milli,
      end_date:self.end_time.to_milli,
      color: '#FFA500',
      sub_courses:{value:self.id,text:self.name,is_default:self.is_default}
    }
  end

end
