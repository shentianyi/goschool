#encoding: utf-8
class CoursePresenter<Presenter
    def_delegators :@course,:id,:name,:description,:actual_number,:expect_number,:lesson,:type,:start_date,:end_date,:tenant_id

    def initialize(course)
     @course=couse
    end

    def tags
      TagUtility.new.get_tags(self.tenant_id,self.class.name,self.id)
    end
end
