class ConsultationPresenter<Presenter
  def_delegators :@consultation, :id,:student_id,:logininfo_id,:consultants,:content,:consult_time,:comment#,:comment_time

  def initialize(consultation)
    @consultation = consultation
  end

  def consult_time_display
    if self.consult_time
      self.consult_time.year.to_s + "-" + self.consult_time.month.to_s + "-" + self.consult_time.day.to_s + " " + self.consult_time.hour.to_s + ":00"
    end
  end

  def recorder
    if self.logininfo_id
      @user = User.find_by_logininfo_id(self.logininfo_id)
      if @user
        @user.name
      end
    end
  end

  def comments
    datas = []
    @consultation.consultcomments.each do |c|
      datas<<{:id=>c.id,:comment=>c.comment,:comment_time=>comment_time_display(c.comment_time)}
    end
    return datas
  end

  def comment_time_display time
    time.year.to_s + "-" + time.month.to_s + "-" +time.day.to_s + " " + time.hour.to_s + ":"+time.min.to_s+":"+time.sec.to_s
  end

  def to_json
    {
      consultation:{
        id:self.id,
        recorder:self.recorder,
        consult_time_display:self.consult_time_display,
        consultants:self.consultants,
        content:self.content,
        comments:self.comments
        #comment:self.comment,
        #comment_time_display:self.comment_time_display
      }
    }
  end
end
