require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test "test_find_by_tag" do
    result=Tag.find_by_tag('1','雅思')

    assert(result.count==3 && result.keys.length==3 && result['1'].length==3)
    assert(result['2'].length==3)
    assert(result['3'].length==3)
    assert(result.keys==['1','2','3'])
    assert(result['1'].sort==['1','2','3'])
    assert(result['2'].sort==['1','2','3'])
    assert(result['3'].sort==['1','2','3'])

  end


  test "find_by_tag_in_entity_type" do
    result = Tag.find_by_tag_in_entity_type('2','2','雅思')
    assert(result.sort == ['1','2','3'])
    result = Tag.find_by_tag_in_entity_type('2','2','雅思1')
    assert(result ==[])
  end

  test "find_by_tags_in_entity_type(tenant_id,entity_type_id,tags,strict=true)" do
      result = Tag.find_by_tags_in_entity_type('2','2',['雅思','tuofu','testinter'])
      assert(result==[])
      result =  Tag.find_by_tags_in_entity_type('2','2',['雅思','tuofu','testinter'],false)
      assert(result.length==3)

      result = Tag.find_by_tags_in_entity_type('2','2',['雅思','tuofu'])
      assert(result.length==3)

      result =  Tag.find_by_tags_in_entity_type('2','2',['雅思','tuofu','testinter'],false)
      assert(result.length==3)

      result =  Tag.find_by_tags_in_entity_type('1','1',['雅思','tuofu','雅思1'])
      assert(result.length==1,"actual #{result.length}")

      result =  Tag.find_by_tags_in_entity_type('1','1',['雅思','tuofu','雅思1'],false)
      assert(result.length==3)
  end

  test "find_by_tags(tenant_id,tags)" do
      result = Tag.find_by_tags('1',['雅思','tuofu','雅思1','雅思2'])
      assert(result.length == 0,"actual #{result.length}")
      result = Tag.find_by_tags('1',['雅思','tuofu','雅思1','雅思2'],false)
     assert(result.length ==10,"actual #{result.length}")
  end

  test "get_tags(tenant_id, entity_type_id,entity_id)" do
    result = Tag.get_tags("1","1","1")
    assert(result.sort == ["tuofu","雅思","雅思1"])
  end

  test "add!(tenant_id,entity_type_id,entity_id,tags)" do
    Tag.add!("1","1","1",["1","2"])
    assert(Tag.get_tags("1","1","1")==["1","2","tuofu","雅思","雅思1"])
  end



  test "unique_add!(tenant_id,entity_type_id,entity_id,tags)" do
    assert_raises(ActiveRecord::RecordNotUnique){Tag.add!("1","1","1",["雅思","2"])}
    assert(Tag.get_tags("1","1","1")==["tuofu","雅思","雅思1"])
  end

  test "remove!(tenant_id,entity_type_id,entity_id,tags)" do
    result= Tag.get_tags("1","1","1")
    assert(result.include?("雅思"))
    Tag.remove!("1","1","1",["雅思"])
    result= Tag.get_tags("1","1","1")
    assert(!result.include?("雅思"))
  end

  test "self.remove_tags!(tenant_id,tags)" do
    result = Tag.where("tenant_id=? and tag=?","1","雅思").length
    assert(result>0)
    Tag.remove_tags!("1",["雅思"])
    result = Tag.where("tenant_id=? and tag=?","1","雅思").length
    assert(result==0)
  end
end
