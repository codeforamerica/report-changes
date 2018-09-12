class StaticPagesController < ApplicationController
  before_action :clear_session

  def index; end

  private

  def clear_session
    session[:current_change_report_id] = nil
  end
end
