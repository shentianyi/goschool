#用于计算推荐列表
#在大数据量时，应该迁移到MapReduce
#可能认识
#1.	学校 同一学校同一年级 300分 ok
#2.	年级 同一学校不同年级 100分 ok
#3.	地区 有限的同一地区分数分级 30＊无地区数据库，暂缓
#4.	标签相似度 50分 ok
#5.	推荐人的推荐人 80分ok
#6.	推荐人同时也推荐的人 80分 ok
#7.	曾经在同一course中学习 200分


#课程
#1.标签符合率 100 ＊标签符合率
#2.学生参加过的课程的标签与课程标签的符合率 －100*标签符合率

class RecommendationScheduler

  #warning! persistence_result will insert the new data intelligently.
  # This function is usually unnecessary to call
  def init_persistence
    RecResult.destroy_all
  end


  #calculate all the Student object on the server and calculate their potential relations
  def cal_all_potential_relation
    type_id = Student.name
    Student.find_each(batch_size:50) do |stud|
      persistence_result(stud.tenant_id,stud.id,type_id,cal_potential_relation(stud.tenant_id,stud.id,type_id))
    end
  end



  #calculate potential relations for a certain Student
  def cal_potential_relation(tenant_id,student_id,type_id)
    do_reduce(type_id,{:tenant_id=>tenant_id,:student_id=>student_id,:entity_type_id=>type_id})
  end



  def cal_all_course_potential_customers()
    type_id = Course.name
    Course.find_each(batch_size:50) do |course|
      persistence_result(course.tenant_id,course.id,type_id,cal_potential_course_customer(course.tenant_id,course.id,type_id))
    end
  end



  def cal_potential_course_customer(tenant_id,course_id,type_id)
    do_reduce(type_id,{:tenant_id=>tenant_id,:course_id=>course_id,:entity_type_id=>type_id})
  end


  #load all the calculate module seperately and reduce here
  def do_reduce(type,arg={})
    result ={}
    init_processors(type)
    @processors[type].each do |process|
      result.merge!(process.calculate(arg)){|key,v1,v2| v1+v2}
    end
    return result
  end

  def init_processors(type)
    @processors || @processors={}
    @processors[type] || load_processors(type)
  end

  def load_processors(type)
    @processors[type] = []
    Dir[File.dirname(__FILE__) + "/#{type.camelize}/*.rb"].each do |path|
      require path
      @processors[type].push(File.basename(path,'.*').camelize.constantize.new)
    end
  end


  #persistence the result
  def persistence_result(tenant_id,target_id,type_id,result)
      if (result && result.is_a?(Hash))
        result.keys.each do |res|
          new_or_update = RecResult.where(\
          'tenant_id=? and rec_target_id=? and entity_type_id=? and reced_id=?',\
          tenant_id,target_id,type_id,res).first_or_create! do |single|
               single.score = result[res]
               single.tenant_id = tenant_id
               single.rec_target_id = target_id
                single.entity_type_id = type_id
              single.reced_id = res
          end
          new_or_update.score = result[res]
          new_or_update.save
        end
      end
  end
end





