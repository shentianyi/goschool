#singleton use Class.instance to load the instance methods
class SearchEngineType
    def initialize

    end

    @@instance = SearchEngineType.new
    @@redis_query = nil


    def self.instance
      return @@instance
    end

    def self.redis_query(redis)
      @@redis_query = redis
    end

    def search_entity_type
      [Student.name,Course.name]
    end


    def search_query_types
      if !@search_query_types
        @search_query_types={}
        search_entity_type.each do |type|
          type =  type.camelize
          Dir[Rails.root + "lib/search/#{type}/*.rb"].each do |path|
            require path
            @search_query_types[type] = {} if(!@search_query_types[type])
            @search_query_types[type][File.basename(path,'.*').camelize]= File.basename(path,'.*').camelize.constantize.new
          end
        end
      end
      return @search_query_types
    end

    #add the set item
    def reindex_all
      index_all
      all_keys = @@redis_query.keys('*')
      validate_type = []

      search_query_types[type.camelize].keys.each do |key|
        validate_type << search_query_types[type.camelize][key].query_type
      end

      if all_keys
        all_keys.each do |key|
           raise exception('unfinished')
        end
      end

    end



    def index_all(flush=false)
      @@redis_query.flushdb if flush
      search_entity_type.each do |type|
        search_query_types[type.camelize].keys.each do |key|
          keys = split_pinyin_or_en(search_query_types[type.camelize][key].index_key_word)
          save_index(type,keys,search_query_types[type.camelize][key].class.name)
        end
      end
    end


    def feed_query_hit(entity_type,key,query_type)
      save_index(entity_type,[key],query_type)
    end


    def save_index(entity_type,keys,query_type)
      keys.uniq.each do |key|
        index_key = mk_index_key(entity_type,key)
        @@redis_query.zincrby(index_key,1,query_type)
      end
    end


    def get_query_types(entity_type,key,limit=10)
      search_key = mk_index_key(entity_type,key)
      result = @@redis_query.zrevrange(search_key,0,limit)
    end


    def mk_index_key(entity_type,key)
      return entity_type + '|' + key
    end


    def split_pinyin_or_en(words)
      tmp_key = []
       if words.is_a?(Array)
         words.collect!{|x| Pinyin.t(x.to_s,splitter:' ').gsub(/\s+/, ' ').strip}.\
               uniq!.reject!{|a| a.empty?}

         #words now looks like ["hello world","course name","ni hao","xxx"],
         # each element will have 1-* word splitted by a space"
         words.each do |word|
           tmp = word.split(' ')
           if tmp.length > 1
             tmp_key << tmp.collect{|p| p[0]}.join('')
              word = word.gsub(/\s+/, '')
           end

           0.upto(word.length-1) do |i|
              tmp_key << word[0..i]
           end
         end
       end
      return tmp_key.uniq
    end


    private_class_method :new

end