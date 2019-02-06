class ClientInfoController < FormsController
  def self.show_rule_sets(report)
    super << report.current_member.client_info_needed?
  end
end
