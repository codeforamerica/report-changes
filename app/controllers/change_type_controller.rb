class ChangeTypeController < FormsController
  helper_method :collection_of_unreported_change_types

  def self.show_rule_sets(report)
    super << report.unreported_change_types.present?
  end

  def collection_of_unreported_change_types
    current_report.unreported_change_types.map do |change|
      { value: change.to_sym, label: t(self_or_other_member_translation_key(".edit." + change)) }
    end
  end
end
