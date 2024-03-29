#encoding: utf-8
class StudentController < ApplicationController
  skip_before_filter :require_user_as_employee
  before_filter :require_user_as_student
  before_filter :get_student
  #layout 'non_authorized'
  layout 'homepage'

  def index
    @active_left_aside = 'homepage'
    @courses = StudentCoursePresenter.init_presenters(Student.course_detail @student.id)
    @shs=@student.student_homeworks.where(marked:true).order('marked_time desc').limit(5).all
    @improved=@student.student_homeworks.where(marked:true,improved:true).count
    @disimproved=@student.student_homeworks.where(marked:true,improved:false).count
    @homeworkds = FrontHomeworkPresenter.init_presenters(StudentHomework.unsubmits(@student.id))
    @sub_courses=@student.sub_courses
  end

  def show
    @active_left_aside = 'achievements'
    # achievementtype id
    @final = Achievement.find_by_type(AchievementType::FINAL)
    @admit = Achievement.find_by_type(AchievementType::ADMITTED)
    @final_grade = Achievement.find_by_type(AchievementType::FINAL_GRADE)
    #
    if @final
      @finals = StudentAchievementPresenter.init_presenters(Achievement.achieves(@final.id, @student.id))
    end

    if @admit
      @admitted = StudentAchievementPresenter.init_presenters(Achievement.achieves(@admit.id, @student.id))
    end

    if @final_grade
      @sub_courses = Achievement.where("type" => AchievementType::SUB_COURSE)
      @final_grades = StudentAchievementPresenter.init_presenters(Achievement.get_result_by_type(AchievementType::SUB_COURSE, @student.id))
    end
  end

  private
  def get_student
    @student = current_logininfo.student
  end
end
