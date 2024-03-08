class WeatherForecastService
  include GeocoderSearch

  attr_reader :search_key, :search_value, :is_cached_forecast, :zip_code

  def initialize(data)
    @search_key = data.keys.first
    @search_value = data[search_key]
    @zip_code = geocode_zip_code(search_value)
    @is_cached_forecast = false
  end

  def call
    forecast_data = cached_result || fetch_forecast_data

    save_to_cache(forecast_data) unless is_cached_forecast

    if forecast_data
      decorate_forecast(forecast_data)
    else
      { 'error': 'Unable to fetch weather data.' }
    end
  end

  private

  def cached_result
    return unless zip_code.present?

    data = Rails.cache.read(zip_code)
    @is_cached_forecast = true if data
    data
  end

  def fetch_forecast_data
    provider_class.new(search_key, search_value).get_data
  rescue => _e
  end

  def save_to_cache(forecast_data)
    Rails.cache.write(zip_code, forecast_data, expires_in: 30.minutes) if zip_code
  end

  def provider_class
    "WeatherProviders::#{weather_client_provider.classify}".safe_constantize
  end

  def decorate_forecast(forecast_data)
    "#{weather_client_provider}_decorator".classify.safe_constantize.new(forecast_data, is_cached_forecast).decorate
  end

  def weather_client_provider
    @weather_client_provider ||= Rails.application.config.weather_provider
  end
end
