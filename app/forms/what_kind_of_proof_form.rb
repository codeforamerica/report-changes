class WhatKindOfProofForm < Form
  set_attributes_for :navigator, :has_offer_letter, :has_paystub

  def save
    change_report.navigator.update(attributes_for(:navigator))
  end
end
