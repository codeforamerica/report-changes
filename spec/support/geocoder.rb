Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      "county" => "Arapahoe",
    },
  ],
)
