class CountyFinder
  COUNTY_ZIP_CODES = {
    "Arapahoe" => [
      "80046",
      "80112",
      "80246",
      "80017",
      "80138",
      "80237",
      "80113",
      "80019",
      "80210",
      "80230",
      "80220",
      "80151",
      "80150",
      "80236",
      "80018",
      "80047",
      "80102",
      "80222",
      "80111",
      "80166",
      "80165",
      "80224",
      "80161",
      "80231",
      "80014",
      "80160",
      "80044",
      "80045",
      "80122",
      "80155",
      "80013",
      "80251",
      "80136",
      "80103",
      "80105",
      "80010",
      "80110",
      "80121",
      "80123",
      "80137",
      "80041",
      "80247",
      "80011",
      "80012",
      "80129",
      "80120",
      "80016",
      "80128",
      "80015",
    ],
  }.freeze

  VALID_COUNTIES = ["Arapahoe"].freeze

  def self.from_zip_code(zip_code)
    zip_code_county_map = {}
    COUNTY_ZIP_CODES.each do |county, county_zip_code|
      county_zip_code.each do |zip|
        zip_code_county_map[zip] = county
      end
    end
    zip_code_county_map[zip_code]
  end
end
