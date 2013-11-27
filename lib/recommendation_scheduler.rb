#用于计算推荐列表
#在大数据量时，应该迁移到MapReduce
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