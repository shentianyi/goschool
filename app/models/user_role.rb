class UserRole < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :role
  belongs_to :logininfo
end
