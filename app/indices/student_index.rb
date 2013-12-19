require 'thinking-sphinx'

ThinkingSphinx::Index.define :student, :with=>:real_time do
  indexes name
  indexes address
  indexes email
  indexes guardian
  indexes school
  indexes phone
  indexes tenant_id
end