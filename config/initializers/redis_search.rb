require "redis"
require "redis-namespace"
require "redis-search"


# don't forget change the namespace
redis_search = Redis::Namespace.new("your_app_name:redis_search", :redis => $redis)
Redis::Search.configure do |config|
  config.redis = redis_search
  config.complete_max_length = 50
  config.pinyin_match = true
  config.disable_rmmseg = false
end