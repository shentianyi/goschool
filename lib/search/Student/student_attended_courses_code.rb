#encoding:UTF-8
class StudentAttendedCoursesCode

  def query_type
    self.class.name
  end

  def name
    '学生参加的课程'
  end

  def introduction
    '按照学生参加过的课程代码查询：'
  end

  def query_type_description
    {:name=>self.name,:introduction=>self.introduction,:parameter_type=>'string',:query_type=>self.class.name}
  end


  def index_key_word
    ['course','course code','课程','课程代码','参加的课程']
  end


  def query(query_obj,parameters)
    if !query_obj
      query_obj = Student.where(true)
    end

    return query_obj.where('id in (?)',ids)
  end



end