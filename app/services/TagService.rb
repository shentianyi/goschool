#encoding: utf-8
class TagService
  def self.add_tags object,tags=nil
    Resque.enqueue(TagAdder,object.tenant_id,object.class.name,object.id,object.tags||tags)
  end
end
