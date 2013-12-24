#encoding:UTF-8
class StudentReferName

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
    ['学生','推荐人','推荐人名字']
  end


  def query(query_obj,parameters)
    if !query_obj
      query_obj = Student.where(true)
    end


    return query_obj
  end



end