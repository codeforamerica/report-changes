class PdfBuilder
  attr_reader :pdf_from_html, :attachments

  def initialize(pdf_from_html:, attachments:)
    @pdf_from_html = pdf_from_html
    @attachments = attachments
  end

  def run
    combined_file = CombinePDF.parse(pdf_from_html)
    attachments.each do |attachment|
      combined_file << CombinePDF.parse(attachment.download)
    end
    combined_file.to_pdf
  end
end
