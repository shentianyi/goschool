#encoding: utf-8
class MaterialObserver<ActiveRecord::Observer
  observe :material


  def after_create material
    if material.materialable.is_a?(Course)
      material.materialable.student_courses.each do |student_course|
        #student_course.material.create
        m=student_course.materials.build
        m.material=material
        m.save
      end
    end
  end
end
