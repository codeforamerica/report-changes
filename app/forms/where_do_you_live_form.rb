class WhereDoYouLiveForm < Form
  set_attributes_for :navigator, :street_address, :city, :zip_code

  validates_presence_of :street_address, message: "Please add your street address"
  validates_presence_of :city, message: "Please add the city you live in"
  validates :zip_code, length: { is: 5, message: "Please add a five digit ZIP code" }

  def save
    change_report.navigator.update!(attributes_for(:navigator).merge(county_from_address: county))
  end

  private

  def county
    @county ||= CountyFinder.new(
      street_address: street_address,
      city: city,
      zip: zip_code,
      state: "CO",
    ).run
  end
end
