module ApplicationHelper
  def destroy
    @instance.destroy
    @msg.result=true
    render :json=>@msg
  end

  private

  def init_message
    @msg=Msg.new
  end

  def model_name
    @model_name=self.class.name.gsub(/Controller/,'').tableize.singularize.downcase
  end

  def model_class
    self.class.name.gsub(/Controller/,'').classify.constantize
  end

  def method_missing(method_name, *args, &block)
    if method_name.to_s=="get_#{model_name}"
      @instance=model_class.find_by_id(params[:id])
    else
    super
    end
  end
end
