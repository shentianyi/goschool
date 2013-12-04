class SearchEngine
  # @param [String] search_queries, a processed search conditions hash
  # @return [ACTIVERECORD::Relation] of the queried object (course, Student)
  def search_return_relation(search_queries)


  end



# @param [String] search_queries, a processed search conditions hash
# @param [Integer] take, the number of records to return
# @param [Integer] from, the index of records to start. Start from 0
# @return [Array] of the queried object (course, Student)
  def search(search_queries,take=-1,from=0)

  end


  def get_query_type(query_type_key)

  end

  def get_all_query_types(entity_type=nil)


  end

end