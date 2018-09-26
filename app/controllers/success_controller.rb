class SuccessController < FormsController
  def next_path(params = {})
    screen_path(SuccessController.to_param, params)
  end
end
