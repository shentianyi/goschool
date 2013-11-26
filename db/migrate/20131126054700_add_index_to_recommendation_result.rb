class AddIndexToRecommendationResult < ActiveRecord::Migration
  def change
    add_index :rec_results,[:tenant_id,:entity_type_id,:rec_target_id],:name=>'rec_result_index_with_three'
    add_index :rec_results,[:tenant_id,:entity_type_id,:rec_target_id,:reced_id],:unique => true,:name=>'rec_result_unique_index_with_four'
  end
end
