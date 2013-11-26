class StudentCoursesController < ApplicationController
  # GET /student_courses
  # GET /student_courses.json
  def index
    @student_courses = StudentCourse.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @student_courses }
    end
  end

  # GET /student_courses/1
  # GET /student_courses/1.json
  def show
    @student_course = StudentCourse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student_course }
    end
  end

  # GET /student_courses/new
  # GET /student_courses/new.json
  def new
    @student_course = StudentCourse.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student_course }
    end
  end

  # GET /student_courses/1/edit
  def edit
    @student_course = StudentCourse.find(params[:id])
  end

  # POST /student_courses
  # POST /student_courses.json
  def create
    @student_course = StudentCourse.new(params[:student_course])

    respond_to do |format|
      if @student_course.save
        format.html { redirect_to @student_course, notice: 'Student course was successfully created.' }
        format.json { render json: @student_course, status: :created, location: @student_course }
      else
        format.html { render action: "new" }
        format.json { render json: @student_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /student_courses/1
  # PUT /student_courses/1.json
  def update
    @student_course = StudentCourse.find(params[:id])

    respond_to do |format|
      if @student_course.update_attributes(params[:student_course])
        format.html { redirect_to @student_course, notice: 'Student course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_courses/1
  # DELETE /student_courses/1.json
  def destroy
    @student_course = StudentCourse.find(params[:id])
    @student_course.destroy

    respond_to do |format|
      format.html { redirect_to student_courses_url }
      format.json { head :no_content }
    end
  end
end
