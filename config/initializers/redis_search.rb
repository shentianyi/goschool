require "redis"
require "redis-namespace"
require "redis-search"


# don't forget change the namespace
redis = Redis.new(:host => "127.0.0.1",:port => "6379")
redis.select(3)
$redis_search = Redis::Namespace.new("GoSchoolTag:redis_search", :redis => redis)
Redis::Search.configure do |config|
  config.redis = $redis_search
  config.complete_max_length = 100
  config.pinyin_match = true
  config.disable_rmmseg =true
end
TagCount.new