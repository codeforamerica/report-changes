class ReportDecorator < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  def self.header_attributes
    [
      "submitted_at",
      "signature",
    ]
  end

  def submitted_at
    super&.in_time_zone("Mountain Time (US & Canada)")&.strftime("%D, %l:%M %p")
  end
end
