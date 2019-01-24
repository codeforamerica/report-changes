class AnyOtherChangesForm < Form
  set_attributes_for :change, :any_other_changes

  validates_presence_of :any_other_changes
end
