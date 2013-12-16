require 'rake'
require "resque/server"
require 'resque/tasks'

Resque::Server.use(Rack::Auth::Basic) do |user, password|
  user="goschool"
  password == "goschool@"
end