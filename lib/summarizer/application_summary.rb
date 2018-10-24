module Summarizer
  class ApplicationSummary
    def initialize(datetime, timezone)
      @date = datetime.in_time_zone(timezone)
      date_range = @date.beginning_of_day..@date.end_of_day

      @change_reports = ChangeReport.
        where(created_at: date_range).
        signed
    end

    def daily_summary
      readable_date = @date.strftime("%a, %b %d")
      "On #{readable_date}, we processed #{change_reports.count} #{application_word}."
    end

    attr_reader :change_reports

    private

    def application_word
      change_reports.count == 1 ? "change report" : "change reports"
    end
  end
end
