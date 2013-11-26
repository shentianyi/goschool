class TagCount < ActiveRecord::Base
  include Redis::Search
  attr_accessible :count, :tag, :tenant_id

  redis_search_index(:title_field => :tag,
                     :score_field => :count,
                     :condition_fields => [:tenant_id])


  #update the tag count
  # @param [String] tenant_id
  # @param [Array] tags
  # @exception: no exception will be raised.
  def self.update_tag_count(tenant_id,tags)
    if tags.is_a?(Array)
      tags.each do |tag|
        exist=TagCount.where('tenant_id=? and tag=?',tenant_id,tag).first
        if exist
          TagCount.increment_counter(:count,exist.id)
          exist.reload
          exist.trig_reindex   # force to trigger the reindex. Increment_counter will not trigger the default after_save call_back
        else
          TagCount.create({:tag=>tag,:tenant_id=>tenant_id,:count=>1})
        end
      end
     end
  end






  def trig_reindex
    self.redis_search_index_create
  end

end
