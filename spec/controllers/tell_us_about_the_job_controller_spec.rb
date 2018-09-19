require "rails_helper"

RSpec.describe TellUsAboutTheJobController do
  it_behaves_like "form controller"

  describe "#edit" do
    it "assigns the fields to the form" do
      current_change_report = create(:change_report,
                                     :with_navigator,
                                     company_name: "Abc Corp",
                                     company_address: "123 Main St Denver",
                                     company_phone_number: "1112223333",
                                     last_day: DateTime.new(2000, 1, 15),
                                     last_paycheck: DateTime.new(2018, 2, 28))

      session[:current_change_report_id] = current_change_report.id

      get :edit

      form = assigns(:form)

      expect(form.company_name).to eq("Abc Corp")
      expect(form.company_address).to eq("123 Main St Denver")
      expect(form.company_phone_number).to eq("1112223333")
      expect(form.last_day_year).to eq(2000)
      expect(form.last_day_month).to eq(1)
      expect(form.last_day_day).to eq(15)
      expect(form.last_paycheck_year).to eq(2018)
      expect(form.last_paycheck_month).to eq(2)
      expect(form.last_paycheck_day).to eq(28)
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          company_name: "Abc Corp",
          company_address: "123 Main St Denver",
          company_phone_number: "111-222-3333",
          last_day_day: "15",
          last_day_month: "1",
          last_day_year: "2000",
          last_paycheck_day: "28",
          last_paycheck_month: "2",
          last_paycheck_year: "2018",
        }
      end

      context "without change report" do
        it "redirects to homepage" do
          put :update, params: { form: valid_params }

          expect(response).to redirect_to(root_path)
        end
      end

      it "redirects to next path and updates the change report" do
        current_change_report = create(:change_report, :with_navigator)
        session[:current_change_report_id] = current_change_report.id

        put :update, params: { form: valid_params }

        current_change_report.reload

        expect(response).to redirect_to(subject.next_path)
        expect(current_change_report.company_name).to eq "Abc Corp"
        expect(current_change_report.company_address).to eq "123 Main St Denver"
        expect(current_change_report.company_phone_number).to eq "1112223333"
        expect(current_change_report.last_day.year).to eq 2000
        expect(current_change_report.last_day.month).to eq 1
        expect(current_change_report.last_day.day).to eq 15
        expect(current_change_report.last_paycheck.year).to eq 2018
        expect(current_change_report.last_paycheck.month).to eq 2
        expect(current_change_report.last_paycheck.day).to eq 28
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          company_name: nil,
        }
      end

      it "renders edit" do
        current_change_report = create(:change_report, :with_navigator)
        session[:current_change_report_id] = current_change_report.id
        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
