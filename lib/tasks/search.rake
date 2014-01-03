require_relative '../search/search_engine_type'
namespace :search do

  desc "index all with flush"
  task :index => :environment do
    SearchEngineType.instance.index_all(true)
    puts 'all search condition indexed'
  end



end