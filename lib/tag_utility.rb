class TagUtility


  # find the entity_type_id and entity_id pairs which contains the input tag
  # @param [String] tenant_id
  # @param [String] tag
  # @return [Array] contains the entity_type_id and entity_id hash
  # like {'1'=>['1','2','3','4','5'],'2'=>['1','2','3','4','5']}
  def find_by_tag(tenant_id,tag)

  end



  #find the ids in the appointed entity type with the input tag
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] tag
  # @return [Array] contains the ids
  def find_by_tag_in_entity_type(tenant_id,entity_type_id,tag)

  end


  #find the ids in the appointed entity type with the input tags
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] tags
  # @return [Array] contains the ids
  def find_by_tags_in_entity_type(tenant_id,entity_type_id,tags)

  end


  # find the entity_type_id and entity_id pairs which contains the input tags
  # @param [String] tenant_id
  # @param [String] tags
  # @return [Array] contains the entity_type_id and entity_id hash
  # like {'1'=>['1','2','3','4','5'],'2'=>['1','2','3','4','5']}
  def find_by_tags(tenant_id,tags)

  end



  #add tags into a certain entity. If the entity does not exist, create it.
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] entity_id
  # @param [Array] tags
  def add(tenant_id,entity_type_id,entity_id,tags)

  end



  #remove_class_variable tags into a certain entity. If the entity does not exist, create it.
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] entity_id
  # @param [Array] tags
  def remove(tenant_id,entity_type_id,entity_id,tags)

  end

  #remove certain tags globally. it will scan all the objects and remove the tags from each of them
  # @param [String] tenant_id
  # @param [Array] tags
  def remove_tags!(tenant_id,tags)

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
  def intersect(tenant_id,entity_type_id_1,entity_id_1,entity_type_id_2,strict_number)

  end





end