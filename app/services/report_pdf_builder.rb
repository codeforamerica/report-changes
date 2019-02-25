class ReportPdfBuilder
  attr_reader :report

  def initialize(report)
    @report = report
  end

  def run
    report_pdf_html = ApplicationController.render(
      layout: "pdf_layout",
      template: "reports/change_report",
      assigns: { report: report },
    )
    report_pdf = WickedPdf.new.pdf_from_string(report_pdf_html)

    change_type_cover_sheet_and_documents = []
    report.reported_changes.each do |change|
      if change.documents.any?
        cover_sheet_html = ApplicationController.render(
          layout: "pdf_layout",
          template: "reports/cover_sheet",
          assigns: { change: change },
        )
        cover_sheet_pdf = WickedPdf.new.pdf_from_string(cover_sheet_html)
        change_type_cover_sheet_and_documents << cover_sheet_pdf

        change.image_documents.each do |image|
          images_html = ApplicationController.render(
            layout: "pdf_layout",
            template: "reports/image",
            assigns: { image: image },
          )
          images_pdf = WickedPdf.new.pdf_from_string(images_html)
          change_type_cover_sheet_and_documents << images_pdf
        end

        change.pdf_documents.each do |pdf|
          change_type_cover_sheet_and_documents << pdf.download
        end
      end
    end
    combined_pdf = CombinePDF.parse(report_pdf)
    change_type_cover_sheet_and_documents.each do |pdf|
      combined_pdf << CombinePDF.parse(pdf)
    end

    length = combined_pdf.pages.length
    combined_pdf.number_pages number_format: " %d / #{length} ", number_location: [:bottom_right]
    combined_pdf.to_pdf
  end
end
