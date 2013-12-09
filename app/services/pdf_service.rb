#encoding: utf-8
class PdfService
  def self.generate_schedule_pdf schedules
    WickedPdf.new.pdf_from_string(ActionController::Base.new().render_to_string('templates/schedule_pdf',
    :layout => "pdfs/schedule",
    :locals => {:schedules => schedules}
    ))
  end
end
