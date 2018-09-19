class Form
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  class_attribute :attribute_names
  attr_accessor :change_report

  def assign_attribute(name, value)
    assign_attributes(name => value)
  end

  class << self
    def set_attributes_for(model, *attributes)
      scoped_attributes[model] = attributes
      self.attribute_names = scoped_attributes.values.flatten
      attribute_strings = Attributes.new(attributes).to_s

      attr_accessor(*attribute_strings)
    end

    def scoped_attributes
      @scoped_attributes ||= {}
    end

    def attributes_for(model)
      scoped_attributes[model] || []
    end
  end

  private

  def strip_dashes(field_name)
    send("#{field_name}=", send(field_name).delete("-")) unless send(field_name).nil?
  end

  def to_datetime(year, month, day)
    DateTime.new(year.to_i, month.to_i, day.to_i)
  end
end
