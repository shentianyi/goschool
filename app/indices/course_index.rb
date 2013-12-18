require 'thinking-sphinx'

ThinkingSphinx::Index.define :course, :with=>:real_time do
  indexes description
  indexes name
  indexes code
end