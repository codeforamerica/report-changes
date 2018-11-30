class HowItWorksController < FormsController
  skip_before_action :ensure_report_present

  layout "sign_post"

  def form_class
    NullForm
  end
end
