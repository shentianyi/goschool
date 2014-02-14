class Material < ActiveRecord::Base
  belongs_to :materialable
  belongs_to :material
  has_many :materials,:dependent => :delete_all

  attr_accessible :description, :name, :status
end
