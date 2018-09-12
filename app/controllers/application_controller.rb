class ApplicationController < ActionController::Base
  helper_method \
    :current_path, :next_path
end
