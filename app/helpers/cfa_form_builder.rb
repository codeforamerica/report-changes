class CfaFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::DateHelper

  def cfa_input_field(
    method,
    label_text,
    type: "text",
    help_text: nil,
    options: {},
    classes: [],
    prefix: nil,
    autofocus: nil,
    optional: false
  )
    classes = classes.append(%w[text-input])

    text_field_options = standard_options.merge(
      autofocus: autofocus,
      type: type,
      class: classes.join(" "),
    ).merge(options).merge(error_attributes(method: method))

    text_field_options[:id] ||= sanitized_id(method)
    options[:input_id] ||= sanitized_id(method)

    text_field_html = text_field(method, text_field_options)

    label_and_field_html = label_and_field(
      method,
      label_text,
      text_field_html,
      help_text: help_text,
      prefix: prefix,
      optional: optional,
      options: options,
    )

    html_output = <<~HTML
      <div class="form-group#{error_state(object, method)}">
      #{label_and_field_html}
      #{errors_for(object, method)}
      </div>
    HTML
    html_output.html_safe
  end

  def cfa_radio_set(
    method,
    label_text: "",
    collection:,
    help_text: nil,
    layouts: ["block"],
    legend_class: ""
  )
    <<~HTML.html_safe
        <fieldset class="form-group#{error_state(object, method)}">
          #{fieldset_label_contents(
            label_text: label_text,
            help_text: help_text,
            legend_class: legend_class,
          )}
      #{cfa_radio_button(method, collection, layouts)}
      #{errors_for(object, method)}
        </fieldset>
    HTML
  end

  private

  def standard_options
    {
      autocomplete: "off",
      autocorrect: "off",
      autocapitalize: "off",
      spellcheck: "false",
    }
  end

  def cfa_radio_button(method, collection, layouts)
    classes = layouts.map { |layout| "input-group--#{layout}" }.join(" ")
    options = { class: classes }.merge(error_attributes(method: method))

    radiogroup_tag = @template.tag(:radiogroup, options, true)

    radio_collection = collection.map do |item|
      item = { value: item, label: item } unless item.is_a?(Hash)

      options = item[:options].to_h

      <<~HTML.html_safe
          <label class="radio-button">
            #{radio_button(method, item[:value], options)}
        #{item[:label]}
          </label>
      HTML
    end
    <<~HTML.html_safe
      #{radiogroup_tag}
          #{radio_collection.join}
            </radiogroup>
    HTML
  end

  def fieldset_label_contents(
    label_text:,
    help_text:,
    legend_class: "",
    optional: false
  )

    label_html = <<~HTML
      <legend class="form-question #{legend_class}">
        #{label_text + optional_text(optional)}
      </legend>
    HTML

    if help_text
      label_html += <<~HTML
        <p class="text--help">#{help_text}</p>
      HTML
    end

    label_html.html_safe
  end

  def label_contents(label_text, help_text, optional)
    label_text = <<~HTML
      <p class="form-question">#{label_text + optional_text(optional)}</p>
    HTML

    if help_text
      label_text << <<~HTML
        <p class="text--help">#{help_text}</p>
      HTML
    end

    label_text.html_safe
  end

  def optional_text(optional)
    if optional
      "<span class='form-card__optional'>(optional)</span>"
    else
      ""
    end
  end

  def label_and_field(
    method,
    label_text,
    field,
    help_text: nil,
    prefix: nil,
    optional: false,
    options: {}
  )
    if options[:input_id]
      for_options = options.merge(
        for: options[:input_id],
      )
      for_options.delete(:input_id)
      for_options.delete(:maxlength)
    end

    formatted_label = label(
      method,
      label_contents(label_text, help_text, optional),
      (for_options || options),
    )
    if prefix
      <<~HTML
        #{formatted_label}
                <div class="text-input-group">
                  <div class="text-input-group__prefix">#{prefix}</div>
                  #{field}
                </div>
      HTML
    else
      formatted_label + field
    end
  end

  def errors_for(object, method)
    errors = object.errors[method]
    if errors.any?
      <<~HTML
        <span class="text--error" id="#{error_label(method)}">
          <i class="icon-warning"></i>
          #{errors.join(', ')}
        </span>
      HTML
    end
  end

  def error_state(object, method)
    errors = object.errors[method]
    " form-group--error" if errors.any?
  end

  def subfield_id(method, position)
    "#{method}_#{position}"
  end

  def subfield_name(method, position)
    "#{method}(#{position})"
  end

  def sanitized_id(method, position = nil)
    name = object_name.to_s.gsub(/([\[\(])|(\]\[)/, "_").gsub(/[\]\)]/, "")

    position ? "#{name}_#{method}_#{position}" : "#{name}_#{method}"
  end

  def aria_label(method)
    "#{sanitized_id(method)}__label"
  end

  def error_label(method)
    "#{sanitized_id(method)}__errors"
  end

  def error_attributes(method:)
    object.errors.present? ? { "aria-describedby": error_label(method) } : {}
  end

  # copied from ActionView::FormHelpers in order to coerce strings with spaces
  # and capitalization to snake case, using the same logic as Rails
  def sanitized_value(value)
    value.to_s.gsub(/\s/, "_").gsub(/[^-[[:word:]]]/, "").mb_chars.downcase.to_s
  end
end
