require "csv"

class CsvService
  attr_reader :active_record_collection

  def initialize(active_record_collection)
    @active_record_collection = active_record_collection
  end

  def run
    CSV.generate(headers: true) do |csv|
      csv << active_record_collection.model.attribute_names

      active_record_collection.each do |active_record_object|
        csv << active_record_object.attributes.values
      end
    end
  end
end