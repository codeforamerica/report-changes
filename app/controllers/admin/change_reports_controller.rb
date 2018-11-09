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
          pdf = ChangeReportPdfBuilder.new(ChangeReportDecorator.new(ChangeReport.find(params[:id]))).run
          send_data pdf, type: "application/pdf", disposition: "inline"
        end
      end
    end

    def download
      change_reports = ChangeReport.signed.map { |change_report| ChangeReportDecorator.new(change_report) }
      csv = CsvService.new(
        active_record_collection: change_reports,
        header_attributes: ChangeReportDecorator.header_attributes,
      ).run

      respond_to do |format|
        format.csv { send_data csv, filename: "change-reports.csv" }
      end
    end
  end
end
