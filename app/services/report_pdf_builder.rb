class ReportPdfBuilder
  attr_reader :report_pdf_from_html, :report

  def initialize(report)
    @report = report

    report_pdf_string = ApplicationController.render(
      layout: "report",
      template: "reports/change_report",
      assigns: { report: report },
    )
    @report_pdf_from_html = WickedPdf.new.pdf_from_string(report_pdf_string)
  end

  def run
    combined_file = CombinePDF.parse(report_pdf_from_html)

    report.reported_changes.each do |change|
      # cover page and images
      change_html = ApplicationController.render(
        layout: "change_docs",
        template: "reports/change_docs",
        assigns: { change: change },
      )
      change_docs_pdf_from_html = WickedPdf.new.pdf_from_string(change_html)
      combined_file << CombinePDF.parse(change_docs_pdf_from_html)

      # pdfs
      change.pdf_documents.each do |pdf|
        combined_file << CombinePDF.parse(pdf.download)
      end
    end

    combined_file.to_pdf
  end
end
