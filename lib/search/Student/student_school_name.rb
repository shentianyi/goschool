#encoding:UTF-8
class StudentSchoolName

  def query_type
    self.class.name
  end

  def name
    '来自学校'
  end

  def introduction
    '按照学生的学校查询：'
  end

  def query_type_description
    {:name=>self.name,:introduction=>self.introduction,:parameter_type=>'string',:query_type=>self.class.name}
  end


  def index_key_word
    ['学生','school','school name','学校','学校名字','就读']
  end


  def query(query_obj,parameters)
    if !query_obj
      query_obj = Student.where(true)
    end
    if parameters
      ids = SearchEngine.new.search_full_text_with_conditions_only_object(Student.name,{:school=>parameters[0]},1,20000)
    end
    return query_obj.where('id in (?)',ids)
  end



end