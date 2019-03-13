class IBIFormBuilder < Cfa::Styleguide::CfaFormBuilder
  def ibi_select(method, label_text, collection, options = {}, html_options = {}, &block)
    <<-HTML.html_safe
      <div class="form-group#{error_state(object, method)}">
        #{label_text.present? ? label(method, label_contents(label_text, options[:notes]), options.fetch(:label_options, {})) : ''}
        <div class="select">
          #{select(method, collection, options, html_options.merge(class: 'select__element'), &block)}
        </div>
        #{errors_for(object, method)}
      </div>
    HTML
  end
end
