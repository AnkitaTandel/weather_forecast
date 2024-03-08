module GeocoderSearch
  def geo_data(data)
    Geocoder.search(data)&.first&.data
  end

  def geocode_country_code(data)
    geo_data(data)&.dig('address', 'country_code')
  end

  def geocode_zip_code(data)
    geo_data(data)&.dig('address', 'postcode')
  end

  def geocode_city(data)
    geo_data(data)&.dig('address', 'city')
  end

  def geocode_state(data)
    geo_data(data)&.dig('address', 'state')
  end
end
