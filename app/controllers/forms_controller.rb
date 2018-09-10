class FormsController < ApplicationController
  layout "form"

  def current_path(params = nil)
    section_path(self.class.to_param, params)
  end

  def self.to_param
    controller_name.dasherize
  end
end
