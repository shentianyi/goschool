#1.不严格匹配课程和学生的TAG
# 2.100分权重乘以TAG匹配程度
# 3.寻找学生已经完成的课程
# 4.根据课程和课程的TAG匹配程度乘以权重80
# 5.1点分数减去4点的分数得出最后总分

class ScoreCourseAttendedCourseTag
  def calculate(arg)
    tenant_id = arg[:tenant_id].to_s
    course_id = arg[:course_id].to_s
    type_id = arg[:entity_type_id].to_s

    result = {}
    #get tags of target student

    tag_utility = TagUtility.new

    tags =tag_utility.get_tags(tenant_id.to_s,type_id.to_s,course_id.to_s)

    if tags
      #find student with similar tag
      potential = tag_utility.find_entity_and_tag_count_in_entity_type(tenant_id,Student.name,tags,false)
      potential.keys.each do |key|
        result[key[2]]=((potential[key].to_f/tags.length)* 100).round
        attended_course = StudentCourse.where('student_id=?',key[2].to_i).pluck(:course_id)
        attended_course.each do |course|
          course_tag = tag_utility.get_tags(tenant_id,type_id,course.to_s)
          result[key[2]]= (result[key[2]] - (((course_tag&tags).length.to_f/tags.length)*80)).round
        end
      end
    end
    return result
  end
end
#
#测试数据准备
#1. 三个课程，一个为主课程，一个为匹配度50%课程，一个为10%课程
#2.三个学生，一个为TAG匹配度0，一个匹配度50，一个匹配度100；一个上过匹配度50的课程，一个上过匹配度10的课程
#最终：两个学生，一个分数10，一个80
#
