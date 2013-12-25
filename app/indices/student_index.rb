require 'thinking-sphinx'

ThinkingSphinx::Index.define :student, :with=>:real_time do
  indexes name
  indexes address
  indexes email
  indexes guardian
  indexes school
  indexes phone
  indexes course_number
  indexes tenant_id
  indexes graduation,:type=>:string
end