class HomeWorksController < ApplicationController
  # GET /home_works
  # GET /home_works.json
  def index
    @home_works = HomeWork.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @home_works }
    end
  end

  # GET /home_works/1
  # GET /home_works/1.json
  def show
    @home_work = HomeWork.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @home_work }
    end
  end

  # GET /home_works/new
  # GET /home_works/new.json
  def new
    @home_work = HomeWork.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @home_work }
    end
  end

  # GET /home_works/1/edit
  def edit
    @home_work = HomeWork.find(params[:id])
  end

  # POST /home_works
  # POST /home_works.json
  def create
    @home_work = HomeWork.new(params[:home_work])

    respond_to do |format|
      if @home_work.save
        format.html { redirect_to @home_work, notice: 'Home work was successfully created.' }
        format.json { render json: @home_work, status: :created, location: @home_work }
      else
        format.html { render action: "new" }
        format.json { render json: @home_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /home_works/1
  # PUT /home_works/1.json
  def update
    @home_work = HomeWork.find(params[:id])

    respond_to do |format|
      if @home_work.update_attributes(params[:home_work])
        format.html { redirect_to @home_work, notice: 'Home work was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @home_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /home_works/1
  # DELETE /home_works/1.json
  def destroy
    @home_work = HomeWork.find(params[:id])
    @home_work.destroy

    respond_to do |format|
      format.html { redirect_to home_works_url }
      format.json { head :no_content }
    end
  end
end
