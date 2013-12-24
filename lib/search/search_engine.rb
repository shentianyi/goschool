require 'search_engine_type'
class SearchEngine


  # @param [String] search_queries, a processed search conditions hash
  # @return [ACTIVERECORD::Relation] of the queried object (course, Student)
  def search_return_relation(entity_type,search_queries,page=1,per_page=20,only_id=false,tenant_id=nil)
    query = nil
    search_queries.each do |proc|
      query = get_query_type(entity_type, proc[:query_type]).query(query,proc[:parameters])
    end
    if tenant_id
      query.where('tenant_id=?',tenant_id)
    end

    query = query.limit(per_page)
    query.offset(page*per_page)

    if only_id
      query = query.select(:id)
    end

    return query
  end


# @param [String] search_type the search type
# @param [String] entity_type the object to search
# @param [String] search_queries, a processed search conditions hash
# @param [Integer] page, the number of records to return
# @param [Integer] per_page, the index of records to start. Start from 0
# @return [Array] of the queried object (course, Student)
  def search(search_type,entity_type,search_queries,page=1,per_page=20,tenant_id=nil)
    case search_type.to_s
      when 'full_text'
        search_full_text(entity_type,search_queries,page,per_page,tenant_id)
      when 'select_query'
        search_return_relation(entity_type,search_queries,page,per_page,tenant_id).all
      else
        return 'search type undefined'
    end
  end



  def search_id(search_type,entity_type,search_queries,page=1,per_page=20,tenant_id=nil)
    case search_type.to_s
      when 'full_text'
        search_full_text_with_object_id(entity_type,search_queries,page,per_page,tenant_id)
      when 'select_query'
        search_return_relation(entity_type,search_queries,page,per_page,tenant_id).select(:id).all
      else
        return 'search type undefined'
    end
  end




  def prepare_search_string(search_queries)
     if !search_queries.is_a?Array
         search_queries= search_queries.split(/[^A-Za-z0-9\u4E00-\u9FA5@\._\+-]+/)
     end
     return Riddle::Query.escape(search_queries.collect{|a| a="*#{a}*"}.join('|'))
  end


  def search_full_text(entity_type,search_queries,page,per_page,tenant_id=nil)
    search_queries=prepare_search_string(search_queries)
    if tenant_id
      entity_type.camelize.constantize.search \
      search_queries,:page => page, :per_page => per_page,:star=>true,:conditions => {:tenant_id => tenant_id.to_s}

    else
      entity_type.camelize.constantize.search search_queries,:star=>true,:page => page, :per_page => per_page
    end
  end



  def search_full_text_with_object_id(entity_type,search_queries,page,per_page,tenant_id=nil,conditions=nil)
    search_queries=prepare_search_string(search_queries)
    if tenant_id

      entity_type.camelize.constantize.search_for_ids\
       search_queries,:page => page,:per_page => per_page,:star=>true,:conditions => {:tenant_id => tenant_id.to_s}
    else
      entity_type.camelize.constantize.search_for_ids search_queries,:star=>true,:page => page,:per_page => per_page
    end
  end

  def search_full_text_with_conditions_only_object(entity_type,conditions,page,per_page,tenant_id=nil)
    if tenant_id
      if !conditions.keys.include?(:tenant_id)
          conditions[:tenant_id]=tenant_id
      end
      entity_type.camelize.constantize.search_for_ids conditions,:star=>true,:page=>page,:per_page=>per_page
    end
  end



  def get_query_type(entity_type,query_type_key)
     return SearchEngineType.instance.search_query_types[entity_type.camelize][query_type_key.camelize]
  end



  #return a hash which contains all the query type object
  def get_all_query_types(entity_type=nil)
    if entity_type
      return SearchEngineType.instance.search_query_types[entity_type.camelize]
    else
      return SearchEngineType.instance.search_query_types
    end
  end


  def get_query_types_by_key(entity_type,key,limit=10)
    type_keys = SearchEngineType.instance.get_query_types(entity_type,key,limit)

    type_objs = []

    type_keys.each do |type_key|
      type_objs.push (self.get_query_type(entity_type,type_key).query_type_description)
    end

    return type_objs

  end








end