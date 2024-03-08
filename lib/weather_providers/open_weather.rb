
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

    private

    def weather_by_address
      client.current_weather(
        zip: geocode_zip_code(search_value),
        city: geocode_city(search_value),
        state: geocode_state(search_value),
        country: geocode_country_code(search_value) || 'US',
        units: 'metric'
      )
    end
  end
end
