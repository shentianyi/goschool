class CourcesController < ApplicationController
  # GET /cources
  # GET /cources.json
  def index
    @cources = Cource.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cources }
    end
  end

  # GET /cources/1
  # GET /cources/1.json
  def show
    @cource = Cource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cource }
    end
  end

  # GET /cources/new
  # GET /cources/new.json
  def new
    @cource = Cource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cource }
    end
  end

  # GET /cources/1/edit
  def edit
    @cource = Cource.find(params[:id])
  end

  # POST /cources
  # POST /cources.json
  def create
    @cource = Cource.new(params[:cource])

    respond_to do |format|
      if @cource.save
        format.html { redirect_to @cource, notice: 'Cource was successfully created.' }
        format.json { render json: @cource, status: :created, location: @cource }
      else
        format.html { render action: "new" }
        format.json { render json: @cource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cources/1
  # PUT /cources/1.json
  def update
    @cource = Cource.find(params[:id])

    respond_to do |format|
      if @cource.update_attributes(params[:cource])
        format.html { redirect_to @cource, notice: 'Cource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cources/1
  # DELETE /cources/1.json
  def destroy
    @cource = Cource.find(params[:id])
    @cource.destroy

    respond_to do |format|
      format.html { redirect_to cources_url }
      format.json { head :no_content }
    end
  end
end
