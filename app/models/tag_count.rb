class TagCount < ActiveRecord::Base
  attr_accessible :count, :tag, :tenant_id
  include Redis::Search


  #update the tag count
  # @param [String] tenant_id
  # @param [Array] tags
  # @exception: no exception will be raised.
  def self.update_tag_count(tenant_id,tags)
    if tags.is_a?(Array)
      tags.each do |tag|
        exist=TagCount.where('tenant_id=? and tag=?',tenant_id,tag)
        if exist
          TagCount.increment_counter(:count,exist.id)
          exist.reload
          exist.trig_reindex
        else
          TagCount.create({:tag=>tag,:tenant_id=>tenant_id,:count=>1})
        end
      end
     end
  end


  redis_search_index(:title_field => :tag,
                     :score_field => :count,
                     :condition_fields => [:tenant_id],
                     :ext_fields => [:tag])



  def trig_reindex
    self.redis_search_index_create
  end

end
