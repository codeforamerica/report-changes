require "csv"

class CsvService
  attr_reader :active_record_collection, :header_attributes

  def initialize(active_record_collection:, header_attributes:)
    @active_record_collection = active_record_collection
    @header_attributes = header_attributes
  end

  def run
    CSV.generate(headers: true) do |csv|
      csv << header_attributes

      active_record_collection.each do |active_record_object|
        csv << header_attributes.map { |attribute| active_record_object.public_send(attribute) }
      end
    end
  end
end
