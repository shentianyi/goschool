#encoding: utf-8
class PdfService
  def self.generate_schedule_pdf schedules
    pdf=WickedPdf.new.pdf_from_string(ActionController::Base.new().render_to_string('templates/schedule_pdf',
    :layout => "pdfs/schedule",
    :locals => {:schedules => schedules}
    ))
    # save_path = Rails.root.join('export/pdf/schedule','filename.pdf')
    # File.open(save_path, 'wb') do |file|
      # file << pdf
    # end
  end
end
