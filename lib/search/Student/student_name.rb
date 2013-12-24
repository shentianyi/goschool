#encoding:UTF-8
class StudentName

  def query_type
    self.class.name
  end

  def name
    '学生名字'
  end

  def introduction
    '按学生名字查询：'
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
      ids = SearchEngine.new.search_full_text_with_object_id(Student.name,parameters[0],1,20)
      return query_obj.where('id in (?)',ids)
    end

  end



end