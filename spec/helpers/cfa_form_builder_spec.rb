require 'rails_helper'

RSpec.describe CfaFormBuilder do
  let(:template) do
    template = OpenStruct.new(output_buffer: "")
    template.extend ActionView::Helpers::FormHelper
    template.extend ActionView::Helpers::DateHelper
    template.extend ActionView::Helpers::FormTagHelper
    template.extend ActionView::Helpers::FormOptionsHelper
  end

  describe "#cfa_radio_set" do
    it "renders an accessible set of radio inputs" do
      class SampleForm < Form
        set_attributes_for :navigator, :selected_county_location
        validates_presence_of :selected_county_location
      end

      form = SampleForm.new
      form.validate
      form_builder = CfaFormBuilder.new("form", form, template, {})
      output = form_builder.cfa_radio_set(
        :selected_county_location,
        label_text: "Do you live in Arapahoe County?",
        collection: [
          { value: :arapahoe, label: "Yes", options: { "data-follow-up": "#yes-follow-up" } },
          { value: :not_arapahoe, label: "No" },
          { value: :not_sure, label: "I'm not sure" },
        ],
        help_text: "This is help text.",
      )
      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <fieldset class="form-group form-group--error">
          <legend class="form-question ">
            Do you live in Arapahoe County?
          </legend>
          <p class="text--help">This is help text.</p>
          <radiogroup class="input-group--block" aria-describedby="form_selected_county_location__errors">
            <label class="radio-button"><div class="field_with_errors"><input data-follow-up="#yes-follow-up" type="radio" value="arapahoe" name="form[selected_county_location]" id="form_selected_county_location_arapahoe"/></div> Yes </label>
            <label class="radio-button"><div class="field_with_errors"><input type="radio" value="not_arapahoe" name="form[selected_county_location]" id="form_selected_county_location_not_arapahoe"/></div> No </label>
            <label class="radio-button"><div class="field_with_errors"><input type="radio" value="not_sure" name="form[selected_county_location]" id="form_selected_county_location_not_sure"/></div> I'm not sure </label>
          </radiogroup>
          <span class="text--error" id="form_selected_county_location__errors"><i class="icon-warning"></i> can't be blank </span>
        </fieldset>
      HTML
    end
  end
end