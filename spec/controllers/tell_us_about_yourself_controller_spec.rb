require "rails_helper"

RSpec.describe TellUsAboutYourselfController do
  it_behaves_like "form controller"

  describe "#edit" do
    it "assigns the fields to the form" do
      current_change_report = create(:change_report,
                                     :with_navigator,
                                     case_number: "1A1234",
                                     phone_number: "1234567890",
                                     member: build(:household_member,
                                              name: "Jane Doe",
                                              ssn: "111223333",
                                              birthday: DateTime.new(1950, 1, 31)))

      session[:current_change_report_id] = current_change_report.id

      get :edit

      form = assigns(:form)

      expect(form.name).to eq("Jane Doe")
      expect(form.birthday_year).to eq(1950)
      expect(form.birthday_month).to eq(1)
      expect(form.birthday_day).to eq(31)
      expect(form.phone_number).to eq("1234567890")
      expect(form.ssn).to eq("111223333")
      expect(form.case_number).to eq("1A1234")
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          name: "Jane Doe",
          phone_number: "111-222-3333",
          ssn: "111-22-3333",
          case_number: "123abc",
          birthday_day: "15",
          birthday_month: "1",
          birthday_year: "2000",
        }
      end

      context "when the member does not yet exist" do
        it "redirects to next path and updates the change report and creates household member" do
          current_change_report = create(:change_report, :with_navigator)
          session[:current_change_report_id] = current_change_report.id

          put :update, params: { form: valid_params }

          current_change_report.reload

          expect(response).to redirect_to(subject.next_path)
          expect(current_change_report.case_number).to eq "123abc"
          expect(current_change_report.phone_number).to eq "1112223333"
          expect(current_change_report.member.name).to eq "Jane Doe"
          expect(current_change_report.member.ssn).to eq "111223333"
          expect(current_change_report.member.birthday.year).to eq 2000
          expect(current_change_report.member.birthday.month).to eq 1
          expect(current_change_report.member.birthday.day).to eq 15
        end
      end

      context "when the member already exists" do
        it "updates the member" do
          current_change_report = create(:change_report,
                                         :with_navigator,
                                         member: build(:household_member, name: "John Doe"))

          session[:current_change_report_id] = current_change_report.id

          expect do
            put :update, params: { form: valid_params }
          end.not_to(change { HouseholdMember.count })

          current_change_report.reload

          expect(response).to redirect_to(subject.next_path)
          expect(current_change_report.member.name).to eq "Jane Doe"
          expect(current_change_report.member.ssn).to eq "111223333"
          expect(current_change_report.member.birthday.year).to eq 2000
          expect(current_change_report.member.birthday.month).to eq 1
          expect(current_change_report.member.birthday.day).to eq 15
        end
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          name: nil,
          phone_number: nil,
          birthday_day: nil,
          birthday_month: nil,
          birthday_year: 2000,
        }
      end

      it "renders edit" do
        put :update, params: { form: invalid_params }

        form = assigns(:form)
        expect(form.birthday_year).to eq "2000"

        expect(response).to render_template(:edit)
      end
    end
  end
end
