 require "rails_helper"

 RSpec.describe DoYouHaveALetterForm do
   describe "validations" do
     context "when no proof types provided" do
       it "is valid" do
         form = DoYouHaveALetterForm.new(nil)

         expect(form).to be_valid
       end
     end

     context "when proof types are valid" do
       it "is valid" do
         form = DoYouHaveALetterForm.new(nil, proof_types: ["final_paycheck"])

         expect(form).to be_valid
       end
     end

     context "when proof types are not valid" do
       it "is invalid" do
         form = DoYouHaveALetterForm.new(nil, proof_types: ["bloop"])

         expect(form).not_to be_valid
         expect(form.errors[:proof_types]).to be_present
       end
     end
   end

   describe "#save" do
     context "when proof types selected" do
       it "persists the values to the correct models" do
         change_report = create(:change_report, :with_navigator)
         form = DoYouHaveALetterForm.new(change_report, proof_types: ["final_paycheck", "termination_letter"])
         form.valid?
         form.save

         change_report.reload

         expect(change_report.navigator.proof_types).to match_array(%w{final_paycheck termination_letter})
       end
     end

     context "when proof types not selected" do
       it "persists the values to the correct models" do
         change_report = create(:change_report, :with_navigator)
         form = DoYouHaveALetterForm.new(change_report, proof_types: nil)
         form.valid?
         form.save

         change_report.reload

         expect(change_report.navigator.proof_types).to match_array([])
       end
     end
   end

   describe ".from_change_report" do
     it "assigns values from change report navigator" do
       navigator = build(:change_report_navigator, proof_types: ["final_paycheck"])
       change_report = create(:change_report, navigator: navigator)

       form = DoYouHaveALetterForm.from_change_report(change_report)

       expect(form.proof_types).to match_array(%w{final_paycheck})
     end
   end
 end
