require "rails_helper"

RSpec.describe Form do
  describe ".attribute_names" do
    it "returns what is set by application and member attributes" do
      class FirstTestForm < Form; end

      FirstTestForm.set_attributes_for :application, :foo
      FirstTestForm.set_attributes_for :member, :bar
      FirstTestForm.set_attributes_for :navigator, :baz

      expect(FirstTestForm.attribute_names).to match_array(%i[foo bar baz])
      expect { FirstTestForm.new(nil).foo }.not_to raise_error
      expect { FirstTestForm.new(nil).bar }.not_to raise_error
      expect { FirstTestForm.new(nil).baz }.not_to raise_error
    end

    it "can accept hashes" do
      class SecondTestForm < Form; end

      SecondTestForm.set_attributes_for :application, foo: []

      expect(SecondTestForm.attribute_names).to match_array([{ foo: [] }])
      expect { SecondTestForm.new(nil).foo }.not_to raise_error
    end
  end

  describe ".analytics_event_name" do
    it "creates a underscored name for the event from form class name" do
      class FourthTestForm < Form; end

      expect(FourthTestForm.analytics_event_name).to eq("fourth_test")
    end
  end
end
