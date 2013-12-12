#encoding: utf-8
class StudentConsultationPresenter<Presenter
  def_delegators :@consultation, :id,:consultants,:consult_time,:content,:comment,:comment_time,:commenter,:logininfo_id
  
  def initialize(consultation)
    @consultation = consultation
  end

  def recorder
    Logininfo.find(self.logininfo_id).user.name
  end

  def to_json
    {
      id: self.id,
      consultants: self.consultants,
      consult_time: self.consult_time,
      contnet: self.content,
      recorder: self.recorder,
      comment: self.comment,
      comment_time: self.comment_time
    }
  end
end
