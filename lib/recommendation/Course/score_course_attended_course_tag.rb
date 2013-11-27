class ScoreCourseAttendedCourseTag
  def calculate(arg)
    tenant_id = arg[:tenant_id]
    course_id = arg[:course_id]
    type_id = arg[:entity_type_id]

    result = {}
    #get tags of target student

    tag_utility = TagUtility.new

    tags =tag_utility.get_tags(tenant_id.to_s,type_id.to_s,course_id.to_s)

    if tags
      #find student with similar tag
      potential = tag_utility.find_entity_and_tag_count_in_entity_type(tenant_id,type_id,tags,false)
      potential.keys.each do |key|
        result[key[2]]=(potential[key]/tags.length)* 100
        attended_course = StudentCourse.where('student_id=?',key[2].to_i).pluck(:course_id)
        attended_course.each do |course|
          course_tag = tag_utility.get_tags(tenant_id,type_id,course.to_s)
          result[key[2]]= result[key[2]] - ((course_tag.length/tags.length)*80)
        end
      end
    end
    return result
  end
end