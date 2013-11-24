class SubCoursesController < ApplicationController
  # GET /sub_courses
  # GET /sub_courses.json
  def index
    @sub_courses = SubCourse.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sub_courses }
    end
  end

  # GET /sub_courses/1
  # GET /sub_courses/1.json
  def show
    @sub_course = SubCourse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sub_course }
    end
  end

  # GET /sub_courses/new
  # GET /sub_courses/new.json
  def new
    @sub_course = SubCourse.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sub_course }
    end
  end

  # GET /sub_courses/1/edit
  def edit
    @sub_course = SubCourse.find(params[:id])
  end

  # POST /sub_courses
  # POST /sub_courses.json
  def create
    @sub_course = SubCourse.new(params[:sub_course])

    respond_to do |format|
      if @sub_course.save
        format.html { redirect_to @sub_course, notice: 'Sub course was successfully created.' }
        format.json { render json: @sub_course, status: :created, location: @sub_course }
      else
        format.html { render action: "new" }
        format.json { render json: @sub_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sub_courses/1
  # PUT /sub_courses/1.json
  def update
    @sub_course = SubCourse.find(params[:id])

    respond_to do |format|
      if @sub_course.update_attributes(params[:sub_course])
        format.html { redirect_to @sub_course, notice: 'Sub course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sub_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_courses/1
  # DELETE /sub_courses/1.json
  def destroy
    @sub_course = SubCourse.find(params[:id])
    @sub_course.destroy

    respond_to do |format|
      format.html { redirect_to sub_courses_url }
      format.json { head :no_content }
    end
  end
end
