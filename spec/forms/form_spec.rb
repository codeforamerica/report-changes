require "rails_helper"

RSpec.describe Form do
  describe ".attribute_names" do
    it "returns what is set by application and member attributes" do
      class TestFormFour < Form; end

      TestFormFour.set_attributes_for :application, :foo
      TestFormFour.set_attributes_for :member, :bar
      TestFormFour.set_attributes_for :navigator, :baz

      expect(TestFormFour.attribute_names).to match_array(%i[foo bar baz])
      expect { TestFormFour.new(nil).foo }.not_to raise_error
      expect { TestFormFour.new(nil).bar }.not_to raise_error
      expect { TestFormFour.new(nil).baz }.not_to raise_error
    end
  end
end
