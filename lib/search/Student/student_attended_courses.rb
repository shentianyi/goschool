#encoding:UTF-8
class StudentAttendedCourses

  def query_type
    self.class.name
  end

  def name
    '学生参加的课程名字'
  end

  def introduction
    '按照学生参加过的课程名字查询：'
  end

  def query_type_description
    {:name=>self.name,:introduction=>self.introduction,:parameter_type=>'string',:query_type=>self.class.name}
  end


  def index_key_word
    ['course','course name','name','课程','课程名字','参加的课程','名字']
  end


  def query(query_obj,parameters)
    if !query_obj
      query_obj = Student.where(true)
    end

    ids = Course.search_for_ids :conditions=>{:name=>parameters},:star=>true

    return query_obj.joins(:courses).where('courses.id in (?)',parameters)
  end



end