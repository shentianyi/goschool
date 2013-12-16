#encoding:UTF-8
class CourseNameExact

  def query_type
    self.class.name
  end

  def name
     '课程名'
  end

  def introduction
     '课程名叫：'
  end

  def query_type_description
    {:name=>self.name,:introduction=>self.introduction,:parameter_type=>'String',:query_type=>self.class.name}
  end


  def index_key_word
     ['course name','课程名','名字','课程']
  end


  def query(query_obj,parameters)
    if !query_obj
      query_obj = Course.where(true==true)
    end
    return query_obj.where('name=?',parameters[0])
  end



end