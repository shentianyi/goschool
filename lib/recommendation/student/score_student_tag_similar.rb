#tag 符合度乘以50分加权
require 'tag_utility'
class ScoreStudentTagSimilar
  def calculate(arg)
    tenant_id = arg[:tenant_id].to_s
    student_id = arg[:student_id].to_s
    type_id = arg[:entity_type_id].to_s

    result = {}
    #get tags of target student

    tag_utility = TagUtility.new

    tags =tag_utility.get_tags(tenant_id.to_s,type_id.to_s,student_id.to_s)

    if tags
      potential = tag_utility.find_entity_and_tag_count_in_entity_type(tenant_id,type_id,tags,false)
      potential.keys.each do |key|
        if key[2]!=student_id
          result[key[2]]=((potential[key].to_f/tags.length)* 50).round
        end
      end
    end
    return result
  end
end

#数据准备
#1. student 6个tag
#1. student 3个相同Tag
#1. student 2个相同tag
#1. Student 1个相同TAG
#N student 没有相同TAG