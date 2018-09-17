require "rails_helper"

RSpec.describe SuccessController do
  it_behaves_like "form controller", is_last_section: true

  describe "show?" do
    it "is always true" do
      show_form = CountyLocationController.show?(nil)
      expect(show_form).to eq(true)
    end
  end
end
