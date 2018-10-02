require "administrate/field/base"

class ChangeReportDownloadLinkField < Administrate::Field::Base
  def to_s
    resource.id
  end
end
