#encoding: utf-8
class SchedulePresenter<Presenter
  def_delegators :@schedule,:name,:parent_name,:id,:start_time,:end_time,:remark,:color,:is_default,:is_base,:institution_name,:teachers
  def initialize(schedule)
    @schedule=schedule
  end
  
  
  def start_hour
   '%02d:%02d' % [self.start_time.hour,self.start_time.min]
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

  def course_name
    self.parent_name  + ( self.name.nil? ? '' : ": #{self.name}")
  end
  
  def teacher_names
      teachers.map{|t| t.name}
    end
    
    def teacher_names_string
      teacher_names.join(', ')
    end

def institution
  @schedule.send :institution_name if @schedule.respond_to?(:institution_name)
end

def remark
  @schedule.remark
end

def color
  @schedule.color
end
  def to_json
    { text:self.parent_name,
      id:self.id,
      teachers:self.teacher_names,
      start_date:self.start_time.to_milli,
      end_date:self.end_time.to_milli,
      remark:self.remark,
      color: self.color || '#FFA500',
      institution_name:self.institution,
      sub_courses:{value:self.id,text:self.name,is_default:self.is_default,is_base:self.is_base}
    }
  end

# local
  
  def start_hour_local
   '%02d:%02d' % [self.start_time.getlocal.hour,self.start_time.getlocal.min]
  end
  
  def end_hour_local
    '%02d:%02d' % [self.end_time.getlocal.hour,self.end_time.getlocal.min]
  end
  
  def start_date_local
    self.start_time.getlocal.strftime('%Y-%m-%d')
  end
  
  def end_date_local
    self.end_time.getlocal.strftime('%Y-%m-%d')
  end
  
  def local_time_string
    "#{start_date_local}  #{start_hour_local}-#{end_hour_local}"
  end
end
