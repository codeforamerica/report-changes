require "csv"

class CsvService
  HEADERS = [
    "report_id",
    "submitted_at",
    "case_number",
    "client_name",
    "birthday",
    "ssn",
    "client_phone_number",
    "change_type",
    "company_name",
    "manager_name",
    "manager_phone_number",
    "manager_additional_information",
    "last_day",
    "last_paycheck",
    "last_paycheck_amount",
    "first_day",
    "paid_yet",
    "first_paycheck",
    "hourly_wage",
    "same_hours",
    "hours_a_week",
    "paid_how_often",
    "new_job_notes",
    "change_in_hours_hours_a_week",
    "change_in_hours_notes",
    "change_in_hours_date",
    "documents_count",
    "signature",
  ].freeze

  def self.run
    CSV.generate(headers: true) do |csv|
      csv << HEADERS

      Report.signed.each do |report_record|
        report_record.reported_changes.each do |change_record|
          report = ReportDecorator.new(report_record)
          change = ChangeDecorator.new(change_record)
          member = MemberDecorator.new(change_record.member)
          csv << [
            report.id,
            report.submitted_at,
            member.case_number,
            member.full_name,
            member.birthday,
            member.ssn,
            member.phone_number,
            change.change_type,
            change.company_name,
            change.manager_name,
            change.manager_phone_number,
            change.manager_additional_information,
            change.last_day,
            change.last_paycheck,
            change.last_paycheck_amount,
            change.first_day,
            change.paid_yet,
            change.first_paycheck,
            change.hourly_wage,
            change.same_hours,
            change.new_job_hours_a_week,
            change.paid_how_often,
            change.new_job_notes,
            change.change_in_hours_hours_a_week,
            change.change_in_hours_notes,
            change.change_date,
            change.documents.count,
            report.signature,
          ]
        end
      end
    end
  end
end
