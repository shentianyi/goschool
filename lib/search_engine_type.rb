#singleton use Class.instance to load the instance methods
class SearchEngineType
    def initialize

    end

    @@instance = SearchEngineType.new


    def self.instance
      return @@instance
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



    def index_all
      search_entity_type.each do |type|
        search_query_types[type.camelize].keys.each do |obj|
          keys = split_pinyin_or_en(obj.index_key_word)
          save_index(type,key,obj.class.name)
        end
      end
    end



    def save_index(entity_type,keys,query_type)
      keys.uniq.each do |key|
        index_key = mk_index_key(entity_type,key)
           raise error("unfinished")
      end
    end

    def get_query_type(entity_type,key)
      search_key = mk_index_key(entity_type,key)
      raise error("unfinished")

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