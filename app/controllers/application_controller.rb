class ApplicationController < ActionController::Base
  helper_method \
    :current_path, :next_path

  respond_to :html

  # For devise routes
  def after_sign_in_path_for(_)
    admin_root_path
  end
end
