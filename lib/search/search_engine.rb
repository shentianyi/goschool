require 'search_engine_type'
class SearchEngine


  # @param [String] search_queries, a processed search conditions hash
  # @return [ACTIVERECORD::Relation] of the queried object (course, Student)
  def search_return_relation(entity_type,search_queries,page=1,per_page=20)
    query = nil
    search_queries.each do |proc|
      query = get_query_type(entity_type, proc[:query_type]).query(query,proc[:parameters])
    end

    query = query.limit(per_page)
    query.offset(page*per_page)
  end


# @param [String] search_type the search type
# @param [String] entity_type the object to search
# @param [String] search_queries, a processed search conditions hash
# @param [Integer] page, the number of records to return
# @param [Integer] per_page, the index of records to start. Start from 0
# @return [Array] of the queried object (course, Student)
  def search(search_type,entity_type,search_queries,page=1,per_page=20)
    case search_type.to_s
      when 'full_text'
        search_full_text(entity_type,search_queries,page,per_page)
      when 'exact'
        search_return_relation(entity_type,search_queries,page,per_page).all
      else
        return 'search type undefined'
    end
  end

  def prepare_search_string(search_queries)
     return search_queries.gsub(/[^A-Za-z0-9@\._\+-]+/,'|')
  end


  def search_full_text(entity_type,search_queries,page,per_page)
    entity_type.camelize.constantize.search search_queries,:page => page, :per_page => per_page
  end

  def search_full_text_with_object_id(entity_type,search_queries,page,per_page)
    entity_type.camelize.constantize.search_for_ids search_queries,:page => page,:per_page => per_page
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