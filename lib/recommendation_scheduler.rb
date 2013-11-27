#用于计算推荐列表
#在大数据量时，应该迁移到MapReduce



#可能认识
#1.	学校 同一学校同一年级 100分
#2.	年级 同一学校不同年级 100分
#3.	地区 有限的同一地区分数分级 30＊
#4.	标签相似度 20分
#5.	推荐人的推荐人 50分
#6.	推荐人同时也推荐的人 50分
#7.	曾经在同一course中学习 80分

class RecommendationScheduler


  def calculate_all_potential_relation(exclude=nil)


  end

  #load all the calculate module seperately and reduce here
  def calculate_potential_relation(tenant_id,student_id)
    processors={}
    Dir[File.dirname(__FILE__) + '/recommendation/student/*.rb'].each do |path|
      processors.merge!(File.basename(path,'.*').camelize.constantize.new.calculate) {|key,v1,v2| v1+v2}
    end
    return processors
  end

  def calculate__all_course_potential_customers(exclude=nil)


  end


  def calculate_potential_course_customer(tenant_id,course_id)

  end




end