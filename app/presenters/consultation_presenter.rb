class ConsultationPresenter<Presenter
  def_delegators :@consultation, :id,:student_id,:logininfo_id,:consultants,:content,:consult_time,:comment,:comment_time

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

  def comment_time_display
    if self.comment_time
      self.comment_time.year.to_s + "-" + self.comment_time.month.to_s + "-" + self.comment_time.day.to_s + " " + self.comment_time.hour.to_s + ":00"
    end
  end

  def to_json
    {
      consultation:{
        id:self.id,
        recorder:self.recorder,
        consult_time_display:self.consult_time_display,
        consultants:self.consultants,
        content:self.content,
        comment:self.comment,
        comment_time_display:self.comment_time_display
      }
    }
  end
end
