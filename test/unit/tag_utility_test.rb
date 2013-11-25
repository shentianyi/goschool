require 'test_helper'
require 'tag_utility.rb'

class TagUtilityTest < ActiveSupport::TestCase
   test "test_construction" do
     assert_nothing_raised(){TagUtility.new}
   end

  test "test_add(tenant_id,entity_type_id,entity_id,tags))" do
   $redis_search.flushall
   utility = TagUtility.new
   tag1 = "ELTSE test"
   tag2 = "TOFEL"
   utility.add!("1","1","1",[tag1,tag2])

   result = Redis::Search.query("TagCount",tag1,{:conditions=>{:tenant_id=>'1'}})
   assert(result.length == 1,"should 1 actual #{result.length}  let's see #{result.to_a}")
   result = Redis::Search.query("TagCount",tag1,{:conditions=>{:tenant_id=>'2'}})
   assert(result.length == 0,"should 0 actual #{result.length}")
  end



   test "test_fast_search(str,top,tenant_id=nil))" do
     $redis_search.flushall
     utility = TagUtility.new
     tag1 = "ELTSE test"
     tag2 = "TOFEL TEST"
     utility.add!("1","1","1",[tag1,tag2])
     utility.add!("2","1","1",[tag2])


     result = utility.fast_search('eltse',1,'1')
     assert(result.length == 1,"should 1 actual #{result.length}  let's see #{result.to_a}")
     result = utility.fast_search('TEST',10)
     assert(result.length == 3,"should 0 actual #{result.length}")

     result = utility.fast_search('kk',10)
     assert(result.length == 0,"should 0 actual #{result.length}")
   end


  test "add_or_update(tenant_id,entity_type_id,entity_id,tags)" do
    $redis_search.flushall
    utility = TagUtility.new
    Tag.destroy_all
    tags_in_db=['托福','雅思','SAT']

    tag_new_1 = ['托福','雅思']
    tag_new_2 = ['托福','雅思','CET-4']

    utility.add!("1","1","1",tags_in_db)
    result = utility.get_tags("1","1","1")
    assert(result.sort==tags_in_db.sort)
     utility.add_or_update("1",'1','1',tag_new_1)
    result = utility.get_tags("1","1","1")
    assert(result.sort==tag_new_1.sort)
    utility.add_or_update("1",'1','1',tag_new_2)
    result = utility.get_tags("1","1","1")
    assert(result.sort==tag_new_2.sort)
  end




end