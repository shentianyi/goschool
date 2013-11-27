class ScoreStudentTagSimilar
  def calculate(arg)
    tenant_id = arg[:tenant_id]
    student_id = arg[:student_id]
    type_id = arg[:entity_type_id]

    result = {}
    #get tags of target student

    tag_utility = TagUtility.new

    tags =tag_utility.get_tags(tenant_id,type_id,student_id)

    if tag
      potential = tag_utility.find_entity_and_tag_count_in_entity_type(tenant_id,type_id,tags,false)
      potential.keys.each do |key|
        if key[2]!=student_id
          result[key[2]]=(potential[key]/tags.length)* 50
        end
      end
    end
    return result
  end
end