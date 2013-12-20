class PostsController < ApplicationController
  skip_before_filter :require_user_as_employee
  before_filter :get_course, :only=>[:index,:create]
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
    @post = PostPresenter.new(Post.find(params[:id]))
    render partial:'post_detail'
  end
  
  #list
  def list
    @type = params[:type].to_i
    get_posts(@type)
    render partial:'list_item'
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
  
  def get_posts menu_type
    @posts = Post.by_type({id:params[:id],menu_type:menu_type})
  end

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
