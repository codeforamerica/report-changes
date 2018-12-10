class ChangeTypeForm < Form
  set_attributes_for :change, :job_termination, :new_job, :change_in_hours

  validate :at_least_one_change_type

  def save
    attributes_for(:change).each do |change_type, value|
      if value == "1"
        report.reported_changes.find_or_create_by(change_type: change_type)
      elsif value == "0"
        report.public_send("#{change_type}_change".to_sym)&.delete
      end
    end
  end

  def at_least_one_change_type
    return true if job_termination == "1" || new_job == "1" || change_in_hours == "1"

    errors.add(:change_type, "Please pick at least one change type.")
  end

  def self.existing_attributes(report)
    hash = {}
    report.reported_changes.each do |change|
      hash[change.change_type] = "1"
    end
    HashWithIndifferentAccess.new(hash)
  end
end
