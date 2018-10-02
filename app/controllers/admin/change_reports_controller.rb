module Admin
  class ChangeReportsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = ChangeReport.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   ChangeReport.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information

    def show
      respond_to do |format|
        format.html do
          super
        end
        format.pdf do
          change_report = ChangeReport.find(params[:id])
          pdf_from_html = render_to_string(
            pdf: "change_report",
            template: "admin/change_reports/show",
            locals: { change_report: ChangeReportDecorator.new(change_report) },
          )

          pdf = PdfBuilder.new(pdf_from_html: pdf_from_html, attachments: change_report.pdf_letters).run
          send_data pdf, type: "application/pdf", disposition: "inline"
        end
      end
    end
  end
end
