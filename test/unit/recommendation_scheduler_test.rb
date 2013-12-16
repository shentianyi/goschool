require 'test_helper'
require 'recommendation_scheduler'

class RecommendationSchedulerTest < ActiveSupport::TestCase
  test "test init table" do
    RecResult.delete_all
    scheduler = RecommendationScheduler.new
    1.upto(50) do |i|
                                        id = i.to_s
       RecResult.create!({:entity_type_id=>id, :reced_id=>id, :score=>100, :tenant_id=>id,:rec_target_id=>id})

    end

     assert(RecResult.count == 50)
    scheduler.init_persistence
    assert(RecResult.count==0)
  end


  test "test persistence result" do

  end


end



