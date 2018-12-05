module Admin
  class ReportsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Report.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Report.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information

    def show
      respond_to do |format|
        format.html do
          super
        end
        format.pdf do
          pdf = ReportPdfBuilder.new(ReportDecorator.new(Report.find(params[:id]))).run
          send_data pdf, type: "application/pdf", disposition: "inline"
        end
      end
    end

    def download
      reports = Report.signed.map { |report| ReportDecorator.new(report) }
      csv = CsvService.new(
        active_record_collection: reports,
        header_attributes: ReportDecorator.header_attributes,
      ).run

      respond_to do |format|
        format.csv { send_data csv, filename: "change-reports.csv" }
      end
    end
  end
end
