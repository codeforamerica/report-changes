class ReportPdfBuilder
  attr_reader :pdf_from_html, :attachments

  def initialize(report)
    rendered_string = ApplicationController.render(
      layout: "report",
      template: "reports/#{report.reported_changes.first.change_type}",
      assigns: { report: report },
    )
    @pdf_from_html = WickedPdf.new.pdf_from_string(rendered_string)

    @attachments = report.reported_changes.first.pdf_documents
  end

  def run
    combined_file = CombinePDF.parse(pdf_from_html)
    attachments.each do |attachment|
      combined_file << CombinePDF.parse(attachment.download)
    end
    combined_file.to_pdf
  end
end
