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
          render pdf: "change_report", locals: { change_report: ChangeReportDecorator.new(change_report) }
        end
      end
    end
  end
end
