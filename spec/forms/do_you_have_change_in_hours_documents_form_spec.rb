 require "rails_helper"

 RSpec.describe DoYouHaveDocumentsForm do
   describe "validations" do
     context "when has_change_in_hours_documents is provided" do
       it "is valid" do
         form = DoYouHaveDocumentsForm.new(nil, has_change_in_hours_documents: "yes")

         expect(form).to be_valid
       end
     end

     context "when has_change_in_hours_documents is not provided" do
       it "is invalid" do
         form = DoYouHaveDocumentsForm.new(nil, has_change_in_hours_documents: nil)

         expect(form).not_to be_valid
         expect(form.errors[:has_change_in_hours_documents]).to be_present
       end
     end
   end

   describe "#save" do
     let(:report) { create :report, :with_navigator }

     let(:valid_params) do
       {
         has_change_in_hours_documents: "yes",
       }
     end

     it "persists the values to the correct models" do
       form = DoYouHaveDocumentsForm.new(report, valid_params)
       form.valid?
       form.save

       report.reload

       expect(report.navigator.has_change_in_hours_documents_yes?).to be_truthy
     end
   end

   describe ".from_report" do
     it "assigns values from change report navigator" do
       report = create(:report, navigator: build(:navigator, has_change_in_hours_documents: "yes"))

       form = DoYouHaveDocumentsForm.from_report(report)

       expect(form.has_change_in_hours_documents).to eq("yes")
     end
   end
 end
