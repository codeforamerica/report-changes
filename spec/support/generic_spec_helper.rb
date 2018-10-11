module GenericSpecHelper
  def with_modified_env(options, &block)
    unless options.all? { |_k, v| v.is_a? String }
      raise "values must all be strings"
    end

    ClimateControl.modify(options, &block)
  end

  def write_raw_pdf_to_temp_file(source:)
    temp_pdf = Tempfile.new("pdf", encoding: "ascii-8bit")
    temp_pdf << source
    temp_pdf
  end
end
