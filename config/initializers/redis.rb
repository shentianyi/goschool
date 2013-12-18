require 'rake'
require "resque/server"
require "resque/tasks"
require 'search_engine_type'

$redis=Redis.new(:host => "127.0.0.1",:port => "6379",:db=>7)
$redis_query =Redis.new(:host => "127.0.0.1",:port => "6379",:db=>8)  #don't use it for other purpose, it will be flushed regularly

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      $redis.client.reconnect
      $redis_query.client.reconnect
      #$redis_search_instance.client.reconnect
      # $redis=Redis.new(:host => "127.0.0.1",:port => "6379",:db=>7)
    end
  end
end


SearchEngineType.redis_query(Redis::Namespace.new('Query',:redis=>$redis_query))


# redis resque
Resque.redis=Redis::Namespace.new("prefix_resque_job_", :redis => $redis)
$recommendation_redis =Redis::Namespace.new('recommendation',:redis=>$redis)
Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }

