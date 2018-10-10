class StaticPagesController < ApplicationController
  before_action :clear_change_report_from_session, :save_source_to_session

  def index; end

  private

  def clear_change_report_from_session
    session[:current_change_report_id] = nil
  end

  def save_source_to_session
    session[:source] = params[:source]
  end
end
