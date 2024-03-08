class WeatherForecastService

  attr_reader :search_key, :search_value

  def initialize(data)
    @search_key = data.keys.first
    @search_value = data[search_key]
  end

  def call
    forecast_data = cached_result || fetch_forecast_data

    if forecast_data
      save_to_cache(forecast_data)
      decorate_forecast(forecast_data)
    else
      { 'error': 'Unable to fetch weather data.' }
    end
  end

  private

  def cached_result
    Rails.cache.read(search_value)
  end

  def fetch_forecast_data
    provider_class.new(search_key, search_value).get_data.merge(cached: false)
  end

  def save_to_cache(forecast_data)
    Rails.cache.write(search_value, forecast_data, expires_in: 30.minutes)
  end

  def provider_class
    "WeatherProviders::#{weather_client_provider.classify}".safe_constantize
  end

  def decorate_forecast(forecast_data)
    "#{weather_client_provider}_decorator".classify.safe_constantize.new(forecast_data).decorate
  end

  def weather_client_provider
    @weather_client_provider ||= Rails.application.config.weather_provider
  end
end
