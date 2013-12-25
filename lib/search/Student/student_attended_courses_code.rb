#encoding:UTF-8
class StudentAttendedCoursesCode

  def query_type
    self.class.name
  end

  def name
    '按学生参加的课程代码查询学生'
  end

  def introduction
    '按照学生参加过的课程代码查询，您需要输入一个准确的课程代码'
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

    return query_obj.joins(:courses).where('courses.code=?',parameters)
  end


end