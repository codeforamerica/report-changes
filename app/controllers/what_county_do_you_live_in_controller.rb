class WhatCountyDoYouLiveInController < FormsController
  skip_before_action :ensure_report_present

  def self.show_rule_sets(_)
    super << false
  end

  def update_session
    session[:current_report_id] = @form.report.id
  end
end
