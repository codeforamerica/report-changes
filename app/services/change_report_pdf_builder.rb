class ChangeReportPdfBuilder
  attr_reader :pdf_from_html, :attachments

  def initialize(change_report)
    rendered_string = ApplicationController.render(
      layout: "change_report",
      template: "change_reports/#{change_report.change_type}",
      assigns: { change_report: ChangeReportDecorator.new(change_report) },
    )
    @pdf_from_html = WickedPdf.new.pdf_from_string(rendered_string)

    @attachments = change_report.pdf_letters
  end

  def run
    combined_file = CombinePDF.parse(pdf_from_html)
    attachments.each do |attachment|
      combined_file << CombinePDF.parse(attachment.download)
    end
    combined_file.to_pdf
  end
end
