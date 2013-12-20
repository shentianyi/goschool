class PostsController < ApplicationController
  skip_before_filter :require_user_as_employee
  before_filter :get_course
  layout "non_authorized"
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.where("course_id"=>params[:id])
    @menus = PostStudentMenuType.generate_menu
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html  #show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html  #new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    msg = Msg.new
    msg.result = false
    
    @post = Post.new(params[:post])
    @post.tenant = current_tenant
    @post.logininfo = current_user
    @post.course = @current_course

    get_attach(params[:attachs],@post)

    msg.result = @post.save
    
    render :json=>msg
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def get_course
    @current_course = Course.find(params[:id])
  end

  private

  def get_attach attachs,target
    unless attachs.blank?
      attachs.each do |index,att|
        path = File.join($AttachPath,att[:pathName])
        #Get from tmp folder and upload to the Cloud Server
        #Delete from tmp folder
        FileUtils.mv(File.join($AttachTmpPath,att[:pathName]),path)
        #
        target.attachments<<Attachment.new(:name=>att[:oriName],:path=>path,:size=>FileData.get_size(path),:type=>FileData.get_type(path))
      end
    end
  end
end
