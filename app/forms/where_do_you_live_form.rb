class WhereDoYouLiveForm < Form
  set_attributes_for :navigator, :street_address, :city, :zip_code

  validates_presence_of :street_address, message: "Please add your street address"
  validates_presence_of :city, message: "Please add the city you live in"
  validates :zip_code, length: { is: 5, message: "Please add a five digit ZIP code" }
end
