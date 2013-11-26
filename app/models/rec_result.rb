class RecResult < ActiveRecord::Base
  attr_accessible :entity_type_id, :reced_id, :score, :tenant_id,:rec_target_id
end
