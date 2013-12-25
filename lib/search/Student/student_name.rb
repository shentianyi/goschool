#encoding:UTF-8
class StudentName

  def query_type
    self.class.name
  end

  def name
    '按学生名字寻找学生'
  end

  def introduction
    '按学生名字查询，您可以输入一个完整的名字或名字的一部分'
  end

  def query_type_description
    {:name=>self.name,:introduction=>self.introduction,:parameter_type=>'string',:query_type=>self.class.name}
  end


  def index_key_word
    ['student name','学生名字','名字','学生']
  end


  def query(query_obj,parameters)
    if !query_obj
      query_obj = Student.where(true)
    end
    if parameters
      engine = SearchEngine.new
      ids = engine.search_full_text_with_object_id(Student.name,engine.prepare_search_string(parameters),1,2000)
      return query_obj.where('students.id in (?)',ids)
    end

  end



end