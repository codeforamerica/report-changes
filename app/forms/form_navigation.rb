class FormNavigation
  MAIN = {
    "Welcome" => [
      HowItWorksController,
    ],
  }.freeze

  class << self
    delegate :first, to: :form_controllers

    def form_controllers
      all
    end

    def all
      MAIN.values.flatten.freeze
    end
  end
end
