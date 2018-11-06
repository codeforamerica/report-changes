class SuccessController < FormsController
  def next_path(params = {})
    screen_path(SuccessController.to_param, params)
  end

  def layout
    "off_ramp"
  end
end
