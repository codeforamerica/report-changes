class FormNavigation
  MAIN = [
    HowItWorksController,
    CountyLocationController,
    SuccessController,
  ].freeze

  class << self
    delegate :first, to: :form_controllers

    def form_controllers
      MAIN
    end
  end

  delegate :form_controllers, to: :class

  def initialize(form_controller)
    @form_controller = form_controller
  end

  def next
    return unless index
    form_controllers_until_end = form_controllers[index + 1..-1]
    form_controllers_until_end.first
  end

  private

  def index
    form_controllers.index(@form_controller.class)
  end
end
