#encoding: utf-8
class TagAdder
  @queue='tag_add_queue'
  def self.perform tenant_id,entity_type_id,entity_id,tags
    TagUtility.new.add_or_update(tenant_id,entity_type_id,entity_id,tags)
  end
end
