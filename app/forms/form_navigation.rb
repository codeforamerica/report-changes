class FormNavigation
  BEGINNING_FLOW = [
    HowItWorksController,
    DemoConfirmationController,
    CountyLocationController,
    WhereDoYouLiveController,
    SupportedCountyController,
    WhatCountyController,
    NotYetSupportedController,
    WhoHadChangeController,
    ClientNameController,
    ChangeTypeController,
    TellUsAboutYourselfController,
    ].freeze

  CLOSING_FLOW = [
    AnyOtherChangesController,
    TextMessageConsentController,
    WantACopyController,
    SignSubmitController,
    SuccessController,
  ].freeze

  JOB_TERMINATION_FLOW = [
    TellUsAboutTheLostJobController,
    TellUsMoreAboutTheLostJobController,
    DoYouHaveLostJobDocumentsController,
    AddLostJobDocumentsController,
  ].freeze

  NEW_JOB_FLOW = [
    SelfEmployedController,
    NotYetSupportedController,
    TellUsAboutTheNewJobController,
    TellUsMoreAboutTheNewJobController,
    HowMuchWillYouMakeController,
    DoYouHaveNewJobDocumentsController,
    AddNewJobDocumentsController,
  ].freeze

  CHANGE_IN_HOURS_FLOW = [
    TellUsAboutChangeInHoursJobController,
    TellUsAboutChangeInHoursController,
    DoYouHaveChangeInHoursDocumentsController,
    AddChangeInHoursDocumentsController,
  ]

  CHANGE_FLOWS = JOB_TERMINATION_FLOW + NEW_JOB_FLOW + CHANGE_IN_HOURS_FLOW

  class << self
    delegate :first, to: :form_controllers

    def form_controllers
      BEGINNING_FLOW + CHANGE_FLOWS + CLOSING_FLOW
    end
  end

  delegate :form_controllers, to: :class

  def initialize(form_controller)
    @form_controller = form_controller
  end

  def next
    return unless index

    form_controllers_until_end = form_controllers[index + 1..-1]
    seek(form_controllers_until_end)
  end

  private

  def index
    form_controllers.index(@form_controller.class)
  end

  def seek(list)
    list.detect do |form_controller_class|
      form_controller_class.show?(@form_controller.current_report)
    end
  end
end
