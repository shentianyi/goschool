class Material < ActiveRecord::Base
  belongs_to :materialable  , :polymorphic=>true
  belongs_to :material
  has_many :materials,:dependent => :delete_all

  attr_accessible :description, :name, :status
  acts_as_tenant(:tenant)
end
