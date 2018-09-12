class CountyLocationForm < Form
  set_attributes_for :navigator, :selected_county_location

  validates_presence_of :selected_county_location,
    message: "Please answer this question"
end
