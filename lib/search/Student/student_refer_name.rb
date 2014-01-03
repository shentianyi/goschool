#encoding:UTF-8
class StudentReferName

  def query_type
    self.class.name
  end

  def name
    '查找某位推荐人推荐过的所有学生'
  end

  def introduction
    '按推荐人姓名查找，您可以输入一个完整或部分推荐人姓名：'
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