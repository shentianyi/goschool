require 'test_helper'

class TagCountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end



  test "should_create_a_new_record_and_index_it" do
     TagCount.where('tenant_id=?','test').destroy_all

      TagCount.update_tag_count('test',['雅思'])
      assert(TagCount.where('tenant_id=?','test').first.count==1)
  end


  test "should update only the count nr if the tag in tenant exist" do
    TagCount.where('tenant_id=?','test').destroy_all
    result=TagCount.create!({:tag=>'雅思',:count=>1,:tenant_id=>'test'})
    TagCount.update_tag_count('test',['雅思'])
    assert(TagCount.where('tenant_id=?','test').first.count==2)
  end

  test "should reindex for existed item" do
    TagCount.where('tenant_id=?','test').destroy_all
    result=TagCount.create!({:tag=>'雅思',:count=>1,:tenant_id=>'test'})
    TagCount.update_tag_count('test',['雅思'])
    result=Redis::Search.complete("TagCount", '雅思', {:limit=>5,:conditions => {:tenant_id => 'test'}})
  assert(result[0]['count']==2)
  end


  test "test chinese" do
    TagCount.where('tenant_id=?','test').destroy_all
    result=TagCount.create!({:tag=>'雅思',:count=>1,:tenant_id=>'test'})
    TagCount.update_tag_count('test',['雅思'])
    result=Redis::Search.complete("TagCount", 'ya', {:limit=>5,:conditions => {:tenant_id => 'test'}})
    assert(result.length==1)
  end


  test "test English and case" do
    TagCount.where('tenant_id=?','test').destroy_all
    result=TagCount.create!({:tag=>'SAT',:count=>1,:tenant_id=>'test'})
    TagCount.update_tag_count('test',['SAT'])
    result=Redis::Search.complete("TagCount", 's', {:limit=>5,:conditions => {:tenant_id => 'test'}})
    assert(result.length==1)
    result=Redis::Search.complete("TagCount", 'sa', {:limit=>5,:conditions => {:tenant_id => 'test'}})
    assert(result.length==1)
    result=Redis::Search.complete("TagCount", 'sat', {:limit=>5,:conditions => {:tenant_id => 'test'}})
    assert(result.length==1)
  end


  test "test multi element" do
    TagCount.where('tenant_id=?','test').destroy_all
    TagCount.create!({:tag=>'SAT',:count=>1,:tenant_id=>'test'})
    TagCount.create!({:tag=>'托福',:count=>1,:tenant_id=>'test'})
    TagCount.create!({:tag=>'雅思',:count=>1,:tenant_id=>'test'})

    TagCount.update_tag_count('test',['SAT','托福','雅思','托业'])
    assert(TagCount.where('tenant_id=? AND tag=?','test','SAT').first.count==2)
    assert(TagCount.where('tenant_id=? AND tag=?','test','托福').first.count==2)
    assert(TagCount.where('tenant_id=? AND tag=?','test','雅思').first.count==2)
    assert(TagCount.where('tenant_id=? AND tag=?','test','托业').first.count==1)
  end


  test "unique key constrain" do
    TagCount.where('tenant_id=?','test').destroy_all
    TagCount.create!({:tag=>'SAT',:count=>1,:tenant_id=>'test'})
    assert_raises(ActiveRecord::RecordNotUnique){TagCount.create!({:tag=>'SAT',:count=>1,:tenant_id=>'test'})}
  end








end
