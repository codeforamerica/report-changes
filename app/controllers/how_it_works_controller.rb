class HowItWorksController < FormsController
  skip_before_action :ensure_change_report_present

  def form_class
    NullForm
  end

  def layout
    "sign_post"
  end
end
