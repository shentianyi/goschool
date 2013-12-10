## Wrapper for different persistence layer.
## the class to support the wrapper should implement all the public  function name in this class

class TagUtility

  # support MYSQL currently
  def initialize(persist='Tag',counter='TagCount')
    @mode = persist
    @instance=  persist.constantize
    @instance_counter = counter.constantize
  end


  # find the entity_type_id and entity_id pairs which contains the input tag
  # @param [String] tenant_id
  # @param [String] tag
  # @return [Array] contains the entity_type_id and entity_id hash  or an empty hash
  # like {'1'=>['1','2','3','4','5'],'2'=>['1','2','3','4','5']}
  def find_by_tag(tenant_id,tag)
    return @instance.find_by_tag(tenant_id,tag)
  end



  #find the ids in the appointed entity type with the input tag
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] tag
  # @return [Array] contains the ids
  def find_by_tag_in_entity_type(tenant_id,entity_type_id,tag)
    return @instance.find_by_tag_in_entity_type(tenant_id,entity_type_id,tag)
  end


  #find the ids in the appointed entity type with the input tags
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] tags
  # @param [Boolean] strict, true to match exactly the tags(no more no less).
  # @return [Array] Tag contains the [#<Tag tenant_id: , entity_type_id: , entity_id: >]
  def find_by_tags_in_entity_type(tenant_id,entity_type_id,tags,strict=true)
    return @instance.find_by_tags_in_entity_type(tenant_id,entity_type_id,tags,strict)
  end


  #find the ids in the appointed entity type with the input tags
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] tags
  # @param [Boolean] strict, true to match exactly the tags(no more no less).
  # @return [Hash] [[tenant_id,entity_type_id,entity_id]=>tag_count]]
  def find_entity_and_tag_count_in_entity_type(tenant_id,entity_type_id,tags,strict=true)
    return  @instance.find_entity_and_tag_count_in_entity_type(tenant_id,entity_type_id,tags,strict)
  end



  # find the entity_type_id and entity_id pairs which contains the input tags
  # @param [String] tenant_id
  # @param [String] tags
  # @param [Boolean] strict, true to match exactly the tags(no more no less).
  # false to select the record matches at least one tag in the input tags
  # @return [Array] contains tags
  # like [#<Tag tenant_id: , entity_type_id: , entity_id: >]
  def find_by_tags(tenant_id,tags,strict=true)
   return @instance.find_by_tags_in_entity_type(tenant_id,entity_type_id,tags,strict)
  end


  #find the ids in the appointed entity type with the input tag
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] entity_id
  # @return [Array] contains the tags of target entity or an empty array if there is no record
  def get_tags(tenant_id, entity_type_id,entity_id)
    return @instance.get_tags(tenant_id, entity_type_id,entity_id)
  end



  #add tags into a certain entity. If the entity does not exist, create it.
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] entity_id
  # @param [Array] tags
  # @exception: raised by create exception
  def add!(tenant_id,entity_type_id,entity_id,tags)
    @instance.add!(tenant_id,entity_type_id,entity_id,tags)
    update_tag_count(tenant_id,tags)
  end

  #update the tag count
  # @param [String] tenant_id
  # @param [Array] tags
  # @exception: no exception will be raised.
  def update_tag_count(tenant_id,tags)
     @instance_counter.update_tag_count(tenant_id,tags)
  end


  #remove tags from a certain entity. If the entity does not exist, ignore it.
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] entity_id
  # @param [Array] tags
  def remove!(tenant_id,entity_type_id,entity_id,tags)
    @instance.remove!(tenant_id,entity_type_id,entity_id,tags)
  end

  #remove certain tags globally. it will scan all the objects and remove the tags from each of them
  # @param [String] tenant_id
  # @param [Array] tags
  def remove_tags!(tenant_id,tags)
    @instance.remove_tags!(tenant_id,tags)
  end



  #Update tags from a certain entity.
  # If remove the tags not in input tags and insert tags in input tags which are not in database
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] entity_id
  # @param [Array] tags
  def add_or_update(tenant_id,entity_type_id,entity_id,tags)
    if tags.is_a?(Array)
      prev = self.get_tags(tenant_id,entity_type_id,entity_id)
      to_delete = prev - tags
      to_insert =  tags-prev
      self.remove!(tenant_id,entity_type_id,entity_id,to_delete) if (to_delete && to_delete.length>0)
      self.add!(tenant_id,entity_type_id,entity_id,to_insert) if(to_insert && to_insert.length>0)
    end
  end


  #full text search of all the exist tags in the system
  # @param [String] tenant_id if it remains nil, whole site's tag will be searched
  # @param [String] str
  # @param [Integer] top records amount should be returned
  # @return [Array] tag contents
  # @note: V1将使用REDIS－Search ＋ mongoid 的组合，这个组合还存在如下问题：
  # 1. SCORE的更新是根据搜索热度而不是最终选择热度来的
  # 2. 必须要有一个持久层
  # 3. 现有机制中，都不支持AUTO_INCREMENT触发REINDEX机制，这造成每次AUTO_INCREMENT后都必须操作一次支持的SAVE或者UPDATE函数
  #    这将不可避免地出现一到两次IO操作
  # 4. 缓存对象被编制为JSON对象后存入REDIS，内存占用大，V3后希望重写整个快速搜索方法
  def fast_search(str,top,tenant_id=nil)
    if tenant_id
      return Redis::Search.query("TagCount", str, {:limit=>top,:conditions => {:tenant_id => tenant_id}})
    else
      return Redis::Search.query("TagCount", str,{:limit=>top})
    end
  end

#try to find a set of entities which has all or part of the tags as the source one
#for example the course with id 1 has tags "reading" "writing", the function will try
# to find the entities with tags "reading" and "writing" or only has "reading" or "writing"
# @param [String] tenant_id
# @param [Object] entity_type_id_1 type of source entity
# @param [Object] entity_id_1   id of source entity
# @param [Object] entity_type_id_2  target entity type id, search all if remains nil
# @param [Object] strict_number number of the target entity. Only the target entity with same or more
#                              of same tags will be returned. place 0 if you want to exactly match (no more no less)
# V2 function
  def intersect(tenant_id,entity_type_id_1,entity_id_1,entity_type_id_2,strict_number)
    @instance.intersect(tenant_id,entity_type_id_1,entity_id_1,entity_type_id_2,strict_number)
  end

end