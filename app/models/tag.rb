class Tag < ActiveRecord::Base
  attr_accessible :entity_id, :entity_type_id, :tag, :tenant_id


  # find the entity_type_id and entity_id pairs which contains the input tag
  # @param [String] tenant_id
  # @param [String] tag
  # @return [Array] contains the entity_type_id and entity_id hash  or an empty hash
  # like {'1'=>['1','2','3','4','5'],'2'=>['1','2','3','4','5']}
  def self.find_by_tag(tenant_id,tag)
    result={}
    Tag.where('tenant_id=? and tag=?',tenant_id,tag).each do |tag|
      if (result.keys.include?(tag.entity_type_id))
        result[tag.entity_type_id].push(tag.entity_id) if !result[tag.entity_type_id].include?(tag.entity_id)
      else
        result[tag.entity_type_id]=[tag.entity_id]
      end
    end
    return result
  end



  #find the ids in the appointed entity type with the input tag
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] tag
  # @return [Array] contains the ids
  def self.find_by_tag_in_entity_type(tenant_id,entity_type_id,tag)
    return Tag.where('tenant_id=? and entity_type_id=? and tag=?',\
                     tenant_id,entity_type_id,tag).pluck(:entity_id)
  end


  #find the ids in the appointed entity type with the input tags
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] tags
  # @param [Boolean] strict, true to match exactly the tags(no more no less).
  # @return [Array] Tag contains the [#<Tag tenant_id: , entity_type_id: , entity_id: >]
  def self.find_by_tags_in_entity_type(tenant_id,entity_type_id,tags,strict=true)
    case strict
      when true
        return  Tag.where('tenant_id=? and entity_type_id=? and tag in (?)',tenant_id,entity_type_id,tags)\
        .select('tenant_id,entity_type_id,entity_id')\
        .group('tenant_id')\
        .group('entity_type_id')\
        .group('entity_id')\
        .having('count(*)=?',tags.length)
      when false
        return  Tag.where('tenant_id=? and entity_type_id=? and tag in (?)',tenant_id,entity_type_id,tags)\
        .select('tenant_id,entity_type_id,entity_id')\
        .group('tenant_id')\
        .group('entity_type_id')\
        .group('entity_id')
    end
  end





  #find the ids in the appointed entity type with the input tags
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] tags
  # @param [Boolean] strict, true to match exactly the tags(no more no less).
  # @return [Hash] [[tenant_id,entity_type_id,entity_id]=>tag_count]]
  def self.find_entity_and_tag_count_in_entity_type(tenant_id,entity_type_id,tags,strict=true)
    case strict
      when true
        return  Tag.where('tenant_id=? and entity_type_id=? and tag in (?)',tenant_id,entity_type_id,tags)\
        .group('tenant_id')\
        .group('entity_type_id')\
        .group('entity_id')\
        .count('tag')
        .having('count(*)=?',tags.length)
      when false
        return  Tag.where('tenant_id=? and entity_type_id=? and tag in (?)',tenant_id,entity_type_id,tags)\
        .select("entity_id,count(*)")\
        .group('tenant_id')\
        .group('entity_type_id')\
        .group('entity_id')
        .count('tag')
    end
  end




  # find the entity_type_id and entity_id pairs which contains the input tags
  # @param [String] tenant_id
  # @param [String] tags
  # @param [Boolean] strict, true to match exactly the tags(no more no less).
  # false to select the record matches at least one tag in the input tags
  # @return [Array] contains tags
  # like [#<Tag tenant_id: , entity_type_id: , entity_id: >]
  def self.find_by_tags(tenant_id,tags,strict=true)
    case strict
      when true
        return  Tag.where('tenant_id=? and tag in (?)',tenant_id,tags)\
        .select('tenant_id,entity_type_id,entity_id')\
        .group('tenant_id')\
        .group('entity_type_id')\
        .group('entity_id')\
        .having('count(*)=?',tags.length)
      when false
        return  Tag.where('tenant_id=? and tag in (?)',tenant_id,tags)\
        .select('tenant_id,entity_type_id,entity_id')\
        .group('tenant_id')\
        .group('entity_type_id')\
        .group('entity_id')
    end
  end


  #find the ids in the appointed entity type with the input tag
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] entity_id
  # @return [Array] contains the tags of target entity or an empty array if there is no record
  def self.get_tags(tenant_id, entity_type_id,entity_id)
    return Tag.where('tenant_id=? and entity_type_id=? and entity_id=?',\
                     tenant_id,entity_type_id,entity_id)\
    .pluck(:tag)
  end



  #add tags into a certain entity. If the entity does not exist, create it.
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] entity_id
  # @param [Array] tags
  # @exception: raised by create exception
  def self.add!(tenant_id,entity_type_id,entity_id,tags)
    to_insert = []
    tags.each do |tag|
      to_insert.push({:tenant_id=>tenant_id,:entity_type_id=>entity_type_id,:entity_id=>entity_id,:tag=>tag})
    end
    Tag.create!(to_insert)
  end



  #remove tags from a certain entity. If the entity does not exist, ignore it.
  # @param [String] tenant_id
  # @param [String] entity_type_id
  # @param [String] entity_id
  # @param [Array] tags
  def self.remove!(tenant_id,entity_type_id,entity_id,tags)
    Tag.where('tenant_id=? and entity_type_id=? and entity_id=? and tag in (?)',\
              tenant_id,entity_type_id,entity_id,tags)\
    .destroy_all
  end

  #remove certain tags globally. it will scan all the objects and remove the tags from each of them
  # @param [String] tenant_id
  # @param [Array] tags
  def self.remove_tags!(tenant_id,tags)
    Tag.where('tenant_id=? and tag in (?)',tenant_id,tags).destroy_all
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
  def self.intersect(tenant_id,entity_type_id_1,entity_id_1,entity_type_id_2,strict_number)

  end
end
