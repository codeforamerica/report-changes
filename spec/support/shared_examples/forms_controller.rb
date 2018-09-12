require "rails_helper"

RSpec.shared_examples_for "form controller" do |is_last_section|
  describe "#current_path" do
    it "returns the path for this route" do
      expect(controller.current_path).to eq "/sections/#{controller.class.to_param}"
    end
  end

  describe "#next_path" do
    it "returns the next path from this controller" do
      form_navigation = FormNavigation.new(controller)

      if is_last_section
        expect(controller.next_path).to be_nil
      else
        expect(controller.next_path).to eq "/sections/#{form_navigation.next.to_param}"
      end
    end
  end
end
