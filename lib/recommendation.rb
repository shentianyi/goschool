
 #this class provide a wrapper to get a recommendation list from the recommendation database.
 # the result will not been calculated on runtime but a schedule and write into the active record database
 # retrieving the recommendation result will go through the cache.
class Recommendation

  # @param [String] student_id  the target Student who need to recommend potential relation
  # @param [String] tenant_id
  # @param [Integer] limit the amount of result to return, the obj will be order by score desc before that
  # @param [Integer] cache_expire_time in minute. Set the expire time of the cache in memcached.Please set this parameter
  # carefully based on the recommendation calculation task frequency
  # @return [Array] of RecResult
  ##<RecResult id:int, tenant_id: string, entity_type_id: string, reced_id: string, score: int, created_at: nil, updated_at: nil>
  #score: the higher the score is, the more possibility of the recommendation is.
  def get_potential_relation(tenant_id,student_id,limit=20,cache_expire_time=30.minutes)
    entity_type_id = Student.name
    get_recommendations(tenant_id,entity_type_id,student_id,cache_expire_time,limit)
  end


  # @param [String] course_id    the target couse which need recommend students
  # @param [String] tenant_id
  # @param [Integer] limit the amount of result to return, the obj will be order by score desc before that
  # @param [Integer] cache_expire_time in minute. Set the expire time of the cache in memcached.Please set this parameter
  # carefully based on the recommendation calculation task frequency
  # @return [Array] of RecResult
  ##<RecResult id:int, tenant_id: string, entity_type_id: string, reced_id: string, score: int, created_at: nil, updated_at: nil>
  #score: the higher the score is, the more possibility of the recommendation is.  def get_course_potential_customers(tenant_id,course_id,limit=20,cache_expire_time=30.minutes)
  def get_potential_student_for_course(tenant_id,course_id,limit=20,cache_expire_time=30.minutes)
    entity_type_id = Course.name
    get_recommendations(tenant_id,entity_type_id,course_id,cache_expire_time,limit)
  end



# @param [String] rec_target_id   the target object which need recommend a list of other object
# @param [String] tenant_id
# @param [Integer] limit the amount of result to return, the obj will be order by score desc before that
# @param [Integer] cache_expire_time in minute. Set the expire time of the cache in memcached.Please set this parameter
# carefully based on the recommendation calculation task frequency
# @return [Array] of RecResult
##<RecResult id:int, tenant_id: string, entity_type_id: string, reced_id: string, score: int, created_at: nil, updated_at: nil>
#score: the higher the score is, the more possibility of the recommendation is.  def get_course_potential_customers(tenant_id,course_id,limit=20,cache_expire_time=30.minutes)
  def get_recommendations(tenant_id,entity_type_id,rec_target_id,cache_expire_time=30.minutes,limit=20)
    Rails.cache.fetch(mk_cache_key(tenant_id,entity_type_id,rec_target_id),:expires_in=>cache_expire_time) do
      RecResult.where('tenant_id=? and entity_type_id=? and rec_target_id=?',\
        tenant_id,entity_type_id,rec_target_id)\
        .order('score desc')\
        .limit(limit)
    end
  end


   #private function to generate an cache key
  def mk_cache_key(tenant_id,obj,obj_id)
    return "#{tenant_id}|#{obj}|#{obj_id}"
  end

end
