#encoding: UTF-8
class StudentGrade
  def query_type
    self.class.name
  end

  def name
    '按毕业时间寻找学生'
  end

  def introduction
    '按毕业时间查找学生，你可以输入一个年份如2013或者加上月份如2013-9'
  end

  def query_type_description
    {:name=>self.name,:introduction=>self.introduction,:parameter_type=>'string',:query_type=>self.class.name}
  end


  def index_key_word
    ['grade','graduation','时间','毕业时间']
  end


  def query(query_obj,parameters)
    if !query_obj
      query_obj = Student.where(true)
    end

    ids = Student.search_for_ids :conditions=>{:graduation=>parameters},:star=>true

    return query_obj.where('students.id in (?)',ids)
  end
end