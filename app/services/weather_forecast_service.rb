class WeatherForecastService

  attr_reader :search_key, :search_value

  def initialize(data)
    @search_key = data.keys.first
    @search_value = data[search_key]
  end

  def call
    forecast_data = if cached_result.present?
                      cached_result.merge!(cached: true)
                    else
                      provider_class.new(search_key, search_value).get_data
                    end

    if forecast_data
      save_to_cache(forecast_data)
      decorator_class.new(forecast_data).decorate
    else
      { 'error': 'Unable to fetch weather data.' }
    end
  end

  private

  def cached_result
    cached_forecast = Rails.cache.read(search_value)
    return nil unless cached_forecast

    cached_forecast
  end

  def save_to_cache(forecast_data)
    # Cache the forecast for 30 minutes
    Rails.cache.write(search_value, forecast_data, expires_in: 30.minutes)
  end

  def provider_class
    provider_name = "WeatherProviders::#{weather_client_provider.classify}"
    provider_name.safe_constantize
  end

  def decorator_class
    decorator_name = "#{weather_client_provider}_decorator".classify
    decorator_name.safe_constantize
  end

  def weather_client_provider
    @weather_client_provider ||= Rails.application.config.weather_provider
  end
end
