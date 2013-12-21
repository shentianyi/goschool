class ConsultcommentPresenter < Presenter
  def_delegators :@consultcomment, :id,:comment,:comment_time,:logininfo_id

  def initialize(consultcomment)
    @consultcomment = consultcomment
  end

  def comment_time_display
    self.comment_time.year.to_s+"-"+self.comment_time.month.to_s+"-"+self.comment_time.day.to_s + " "+self.comment_time.hour.to_s+":"+self.comment_time.min.to_s+":"+self.comment_time.sec.to_s
  end

  def to_json
    {
      consultcomment:{
        id: self.id,
        comment: self.comment,
        comment_time: self.comment_time_display
      }
    }
  end
end
