require "rails_helper"

RSpec.describe CfaFormBuilder do
  let(:template) do
    template = OpenStruct.new(output_buffer: "")
    template.extend ActionView::Helpers::FormHelper
    template.extend ActionView::Helpers::DateHelper
    template.extend ActionView::Helpers::FormTagHelper
    template.extend ActionView::Helpers::FormOptionsHelper
  end

  describe "#cfa_checkbox" do
    it "renders an accessible checkbox input" do
      class SampleForm < Form
        set_attributes_for(:member, :read_tos)
        validates_presence_of :read_tos
      end

      sample = SampleForm.new
      sample.validate
      form = CfaFormBuilder.new("sample", sample, template, {})
      output = form.cfa_checkbox(
        :read_tos,
        "Confirm that you agree to Terms of Service",
      )

      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
      <fieldset class="input-group form-group form-group--error">
        <label class="checkbox">
          <input name="sample[read_tos]" type="hidden" value="0" />
          <div class="field_with_errors">
            <input aria-describedby="sample_read_tos__errors" type="checkbox" value="1" name="sample[read_tos]" id="sample_read_tos"/>
          </div>
          Confirm that you agree to Terms of Service
        </label>
        <span class="text--error" id="sample_read_tos__errors">
          <i class="icon-warning"></i> can't be blank
        </span>
      </fieldset>
      HTML
    end

    context "when checkbox value is equal to checked value" do
      it "renders checkbox as selected" do
        class SampleForm < Form
          set_attributes_for(:member, :read_tos)
        end

        sample = SampleForm.new(read_tos: "yes")
        form = CfaFormBuilder.new("sample", sample, template, {})
        output = form.cfa_checkbox(:read_tos,
          "Confirm that you agree to Terms of Service",
          options: {
            checked_value: "yes",
            unchecked_value: "no",
          })

        expect(output).to be_html_safe

        expect(output).to match_html <<-HTML
        <fieldset class="input-group form-group">
          <label class="checkbox">
            <input name="sample[read_tos]" type="hidden" value="no" />
            <input checked_value="yes" unchecked_value="no" type="checkbox" value="yes" checked="checked" name="sample[read_tos]" id="sample_read_tos" />
            Confirm that you agree to Terms of Service
          </label>
        </fieldset>
        HTML
      end
    end

    context "when checkbox is disabled and value is equal to checked value" do
      it "renders disabled checkbox as selected" do
        class SampleForm < Form
          set_attributes_for(:member, :read_tos)
        end

        sample = SampleForm.new(read_tos: "yes")
        form = CfaFormBuilder.new("sample", sample, template, {})
        output = form.cfa_checkbox(:read_tos,
          "Confirm that you agree to Terms of Service",
          options: {
            checked_value: "yes",
            unchecked_value: "no",
            disabled: true,
          })

        expect(output).to be_html_safe

        expect(output).to match_html <<-HTML
        <fieldset class="input-group form-group">
          <label class="checkbox is-selected is-disabled">
            <input name="sample[read_tos]" disabled="disabled" type="hidden" value="no" />
            <input checked_value="yes" unchecked_value="no" disabled="disabled" type="checkbox" value="yes" checked="checked" name="sample[read_tos]" id="sample_read_tos" />
            Confirm that you agree to Terms of Service
          </label>
        </fieldset>
        HTML
      end
    end
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

  describe "#cfa_input_field" do
    it "renders a label that contains a p tag" do
      class SampleForm < Form
        set_attributes_for :navigator, :name
      end

      form = SampleForm.new
      form_builder = CfaFormBuilder.new("form", form, template, {})
      output = form_builder.cfa_input_field(:name, "How is name?")
      expect(output).to be_html_safe
      expect(output).to match_html <<-HTML
        <div class="form-group">
          <label for="form_name">
            <p class="form-question">How is name?</p>
          </label>
          <input autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" type="text" class="text-input" id="form_name" name="form[name]" />
        </div>
      HTML
    end

    it "adds help text and error ids to aria-labelledby" do
      class SampleForm < Form
        set_attributes_for :navigator, :name
        validates_presence_of :name
      end

      form = SampleForm.new
      form.validate

      form_builder = CfaFormBuilder.new("form", form, template, {})
      output = form_builder.cfa_input_field(
        :name,
        "How is name?",
        help_text: "Name is name",
      )
      expect(output).to be_html_safe
      expect(output).to match_html <<-HTML
        <div class="form-group form-group--error">
          <div class="field_with_errors">
            <label for="form_name">
              <p class="form-question">How is name?</p>
              <p class="text--help"">Name is name</p>
            </label>
          </div>
          <div class="field_with_errors">
            <input autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" type="text" class="text-input" aria-describedby="form_name__errors" id="form_name" name="form[name]" />
          </div>
          <span class="text--error" id="form_name__errors"><i class="icon-warning"></i> can't be blank </div>
        </div>
      HTML
    end
  end

  describe "#cfa_date_select" do
    it "renders an accessible date select" do
      class SampleForm < Form
        set_attributes_for :member,
                           :birthday_year,
                           :birthday_month,
                           :birthday_day
      end

      form = SampleForm.new
      form.birthday_year = 1990
      form.birthday_month = 3
      form.birthday_day = 25
      form_builder = CfaFormBuilder.new("form", form, template, {})
      output = form_builder.cfa_date_select(
        :birthday,
        "What is your birthday?",
        help_text: "(For surprises)",
        options: {
          start_year: 1990,
          end_year: 1992,
          order: %i{month day year},
        },
      )
      expect(output).to be_html_safe

      expect(output).to match_html <<-HTML
        <fieldset class="form-group">
          <legend class="form-question "> What is your birthday? </legend>
          <p class="text--help">(For surprises)</p>
          <div class="input-group--inline">
            <div class="select">
              <label for="form_birthday_month" class="sr-only">Month</label>
              <select id="form_birthday_month" name="form[birthday_month]" class="select__element">
                <option value="">Month</option>
                <option value="1">January</option>
                <option value="2">February</option>
                <option value="3" selected="selected">March</option>
                <option value="4">April</option>
                <option value="5">May</option>
                <option value="6">June</option>
                <option value="7">July</option>
                <option value="8">August</option>
                <option value="9">September</option>
                <option value="10">October</option>
                <option value="11">November</option>
                <option value="12">December</option>
              </select>
            </div>
            <div class="select">
              <label for="form_birthday_day" class="sr-only">Day</label>
              <select id="form_birthday_day" name="form[birthday_day]" class="select__element">
                <option value="">Day</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
                <option value="7">7</option>
                <option value="8">8</option>
                <option value="9">9</option>
                <option value="10">10</option>
                <option value="11">11</option>
                <option value="12">12</option>
                <option value="13">13</option>
                <option value="14">14</option>
                <option value="15">15</option>
                <option value="16">16</option>
                <option value="17">17</option>
                <option value="18">18</option>
                <option value="19">19</option>
                <option value="20">20</option>
                <option value="21">21</option>
                <option value="22">22</option>
                <option value="23">23</option>
                <option value="24">24</option>
                <option value="25" selected="selected">25</option>
                <option value="26">26</option>
                <option value="27">27</option>
                <option value="28">28</option>
                <option value="29">29</option>
                <option value="30">30</option>
                <option value="31">31</option>
              </select>
            </div>
            <div class="select">
              <label for="form_birthday_year" class="sr-only">Year</label>
              <select id="form_birthday_year" name="form[birthday_year]" class="select__element">
                <option value="">Year</option>
                <option value="1990" selected="selected">1990</option>
                <option value="1991">1991</option>
                <option value="1992">1992</option>
              </select>
            </div>
          </div>
        </fieldset>
      HTML
    end
  end
end
