
module WeatherProviders
  class OpenWeather
    include GeocoderSearch

    attr_reader :search_key, :search_value

    def initialize(search_key, search_value)
      @search_key = search_key
      @search_value = search_value
    end

    def client
      @client ||= ::OpenWeather::Client.new(api_key: Rails.application.config.open_weather_api_key)
    end

    def get_data
      send("weather_by_#{search_key}")
    rescue NoMethodError => e
      raise 'Unable to fetch weather data. Please provide correct inputs.'
    end

    def weather_by_zip_code
      client.current_zip(
        zip: search_value,
        units: 'metric',
        country: geocode_country_code(search_value) || 'US'
      )
    rescue => e
    end
  end
end
