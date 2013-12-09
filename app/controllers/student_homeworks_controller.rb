class StudentHomeworksController < ApplicationController
  # GET /student_homeworks
  # GET /student_homeworks.json
  def index
    @student_homeworks = StudentHomework.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @student_homeworks }
    end
  end

  # GET /student_homeworks/1
  # GET /student_homeworks/1.json
  def show
    @student_homework = StudentHomework.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student_homework }
    end
  end

  # GET /student_homeworks/new
  # GET /student_homeworks/new.json
  def new
    @student_homework = StudentHomework.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student_homework }
    end
  end

  # GET /student_homeworks/1/edit
  def edit
    @student_homework = StudentHomework.find(params[:id])
  end

  # POST /student_homeworks
  # POST /student_homeworks.json
  def create
    @student_homework = StudentHomework.new(params[:student_homework])

    respond_to do |format|
      if @student_homework.save
        format.html { redirect_to @student_homework, notice: 'Student homework was successfully created.' }
        format.json { render json: @student_homework, status: :created, location: @student_homework }
      else
        format.html { render action: "new" }
        format.json { render json: @student_homework.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /student_homeworks/1
  # PUT /student_homeworks/1.json
  def update
    @student_homework = StudentHomework.find(params[:id])

    respond_to do |format|
      if @student_homework.update_attributes(params[:student_homework])
        format.html { redirect_to @student_homework, notice: 'Student homework was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student_homework.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_homeworks/1
  # DELETE /student_homeworks/1.json
  def destroy
    @student_homework = StudentHomework.find(params[:id])
    @student_homework.destroy

    respond_to do |format|
      format.html { redirect_to student_homeworks_url }
      format.json { head :no_content }
    end
  end
end
