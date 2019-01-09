module GenericSpecHelper
  def with_modified_env(options, &block)
    unless options.all? { |_k, v| v.is_a? String }
      raise "values must all be strings"
    end

    ClimateControl.modify(options, &block)
  end

  def pdf_to_text(pdf)
    temp_pdf = Tempfile.new("pdf", encoding: "ascii-8bit")
    temp_pdf << pdf
    PDF::Reader.new(temp_pdf).pages.map do |page|
      page.text.gsub("\t", " ").gsub("\n", " ").squeeze(" ")
    end.join(" ")
  end
end
