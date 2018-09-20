 require "rails_helper"

 RSpec.describe DoYouHaveALetterForm do
   describe "validations" do
     context "when has_letter is provided" do
       it "is valid" do
         form = DoYouHaveALetterForm.new(
           has_letter: "yes",
         )

         expect(form).to be_valid
       end
     end

     context "when has_letter is not provided" do
       it "is invalid" do
         form = DoYouHaveALetterForm.new(
           has_letter: nil,
         )

         expect(form).not_to be_valid
         expect(form.errors[:has_letter]).to be_present
       end
     end
   end

   describe "#save" do
     let(:change_report) { create :change_report, :with_navigator }

     let(:valid_params) do
       {
         change_report: change_report,
         has_letter: "yes",
       }
     end

     it "persists the values to the correct models" do
       form = DoYouHaveALetterForm.new(valid_params)
       form.valid?
       form.save

       change_report.reload

       expect(change_report.navigator.has_letter_yes?).to be_truthy
     end
   end
 end
