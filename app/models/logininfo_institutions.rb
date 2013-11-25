class LogininfoInstitutions < ActiveRecord::Base
  belongs_to :logininfo
  # attr_accessible :title, :body
  attr_accessible :institution_id,:logininfo_id
end
