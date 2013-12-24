#encoding:UTF-8
class StudentNotAttendedCourse

  def query_type
    self.class.name
  end

  def name
    '学生没有参加的课程名称'
  end

  def introduction
    '按照学生没有参加过的课程名称查询：'
  end

  def query_type_description
    {:name=>self.name,:introduction=>self.introduction,:parameter_type=>'string',:query_type=>self.class.name}
  end


  def index_key_word
    ['course','course name','name','课程','课程名','参加的课程','没参加','未参加']
  end



  def query(query_obj,parameters)
    if !query_obj
      query_obj = Student.where(true)
    end

    ids = Course.search_for_ids :conditions=>{:name=>parameters[0]},:star=>true

    return query_obj.where('students.id not in (select student_id from student_courses,courses where courses.id=student_courses.id and courses.id in (?))', ids)
  end



end