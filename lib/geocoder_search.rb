module GeocoderSearch
  def geo_data(data)
    Geocoder.search(data)
  end

  def geocode_country_code(data)
    result = geo_data(data)
    return unless result&.first

    result.first.data["address"]["country_code"]
  end
end
