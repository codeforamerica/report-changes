class TellUsAboutYourselfController < FormsController
  def self.show_rule_sets(report)
    super << report.member.birthday.nil?
  end
end
