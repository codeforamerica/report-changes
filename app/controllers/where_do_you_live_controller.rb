class WhereDoYouLiveController < FormsController
  def self.skip_rule_sets(change_report)
    super << SkipRules.must_not_know_county_location(change_report)
  end

  def update_models
    current_change_report.navigator.update!(params_for(:navigator).merge(county_from_address: county))
  end

  private

  def county
    @county ||= CountyFinder.new(
      street_address: form_params[:street_address],
      city: form_params[:city],
      zip: form_params[:zip_code],
      state: "CO",
    ).run
  end

  def existing_attributes
    HashWithIndifferentAccess.new(current_change_report.navigator.attributes)
  end
end
