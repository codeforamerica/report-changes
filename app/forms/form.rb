class Form
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations::Callbacks

  class_attribute :attribute_names
  attr_accessor :change_report

  def initialize(change_report, params = {})
    @change_report = change_report
    super(params)
  end

  def assign_attribute(name, value)
    assign_attributes(name => value)
  end

  def attributes_for(model)
    self.class.scoped_attributes[model].reduce({}) do |hash, attribute_name|
      hash[attribute_name] = send(attribute_name)
      hash
    end
  end

  class << self
    def set_attributes_for(model, *attributes)
      scoped_attributes[model] = attributes
      self.attribute_names = scoped_attributes.values.flatten
      attribute_strings = Attributes.new(attributes).to_s

      attr_accessor(*attribute_strings)
    end

    def from_change_report(change_report)
      attribute_keys = Attributes.new(attribute_names).to_sym
      new(change_report, existing_attributes(change_report).slice(*attribute_keys))
    end

    def scoped_attributes
      @scoped_attributes ||= {}
    end

    # Override in subclasses if needed

    def existing_attributes(change_report)
      HashWithIndifferentAccess.new(change_report.attributes)
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
