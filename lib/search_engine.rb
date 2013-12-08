require 'search_engine_type'
class SearchEngine


  # @param [String] search_queries, a processed search conditions hash
  # @return [ACTIVERECORD::Relation] of the queried object (course, Student)
  def search_return_relation(entity_type,search_queries,take=-1,offset=0)
    query = nil
    search_queries.each do |proc|
      query = get_query_type(entity_type, proc[:query_type]).query(query,proc[:parameters])
    end
    if limit >0
      query = query.limit(limit)
    end
    query.offset(offset)
  end


# @param [String] search_type the search type
# @param [String] entity_type the object to search
# @param [String] search_queries, a processed search conditions hash
# @param [Integer] take, the number of records to return
# @param [Integer] offset, the index of records to start. Start from 0
# @return [Array] of the queried object (course, Student)
  def search(search_type,entity_type,search_queries,take=-1,offset=0)
    case search_type.to_s
      when 'full_text'
        search_full_text(entity_type,search_queries)
      when 'exact'
        search_return_relation(entity_type,search_queries,take,offset).all
      else
        return 'search type undefined'
    end
  end



  def search_full_text(entity_type,search_queries)


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



  def index_query_type

  end




end