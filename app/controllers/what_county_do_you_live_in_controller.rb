class WhatCountyDoYouLiveInController < FormsController
  skip_before_action :ensure_report_present

  helper_method :county_drop_down_collection

  def self.show_rule_sets(_)
    super << false
  end

  def update_session
    session[:current_report_id] = @form.report.id
  end

  def county_drop_down_collection
    CountyService::VALID_COUNTIES + ["Not listed"]
  end
end
