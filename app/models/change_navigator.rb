class ChangeNavigator < ActiveRecord::Base
  belongs_to :change, dependent: :destroy

  enum has_documents: { unfilled: 0, yes: 1, no: 2 }, _prefix: :has_documents
  enum is_self_employed: { unfilled: 0, yes: 1, no: 2 }, _prefix: :is_self_employed
end
