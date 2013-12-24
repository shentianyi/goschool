#encoding:UTF-8
class CourseName

  def query_type
    self.class.name
  end

  def name
     '按课程名查询'
  end

  def introduction
     '课程名叫：'
  end

  def query_type_description
    {:name=>self.name,:introduction=>self.introduction,:parameter_type=>'string',:query_type=>self.class.name}
  end


  def index_key_word
     ['course name','课程名','名字','课程']
  end


  def query(query_obj,parameters)
    if !query_obj
      query_obj = Course.where(true==true)
    end

    ids = Course.search :conditions=>{:name=>parameters}, :star=>true

    return query_obj.where('courses.id in (?)', ids)

  end



end