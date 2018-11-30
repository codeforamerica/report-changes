require "administrate/field/base"

class DownloadLinkField < Administrate::Field::Base
  def to_s
    resource.id
  end
end
