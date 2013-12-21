#encoding: utf-8
class StudentHomeworkPresenter<Presenter
    def_delegators :@student_homework,:id,:content,:improved,:marked,:marked_time,:score,:submited_time,:homework_id,:name,:stuent_id,:attachments,:can_resubmit?
    def initialize(student_homework)
	@student_homework=student_homework
    end

    def submited_time_display
	if (diff=Date.current.mjd-self.submited_time.to_date.mjd)==0
	  "今天"
	elsif diff<4
	    "#{diff}天前"
	else
	    "#{self.submited_time.strftime('%Y-%m-%d')}"
	end + ",由#{self.name}提出"
end

    def marked_time_display
	if (diff=Date.current.mjd-self.marked_time.to_date.mjd)==0
	    "今天"
	elsif diff<4
	    "#{diff}天前"
	else
	    "#{self.marked_time.strftime('%Y-%m-%d')}"
	end +"，批改" if self.marked
    end

    def score_display
     return self.score.to_i if self.score.to_i==self.score
     self.score
    end
end
