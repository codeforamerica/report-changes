require "administrate/field/base"

class CaseNumberField < Administrate::Field::Base
  def to_s
    resource&.submitter&.case_number || resource&.members.first.case_number
  end
end
