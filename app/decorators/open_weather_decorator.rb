class OpenWeatherDecorator < Draper::Decorator
  attr_reader :forecast_data, :cached

  def initialize(forecast_data, cached=false)
    @forecast_data = forecast_data
    @cached = cached
  end

  def decorate
    {
      country: country,
      city: city,
      temperature: temperature,
      maximum_temperature: maximum_temperature,
      minimum_temperature: minimum_temperature,
      humidity: humidity,
      pressure: pressure,
      cached: cached ? 'Result pulled from cache.' : 'Result pulled from API.'
    }
  end

  private

  def formatted_temp(temp)
    "#{temp} C"
  end

  def temperature
    formatted_temp(forecast_data.dig('main', 'temp'))
  end

  def minimum_temperature
    formatted_temp(forecast_data.dig('main', 'temp_min'))
  end

  def maximum_temperature
    formatted_temp(forecast_data.dig('main', 'temp_max'))
  end

  def humidity
    formatted_temp(forecast_data.dig('main', 'humidity'))
  end

  def pressure
    formatted_temp(forecast_data.dig('main', 'pressure'))
  end

  def country
    forecast_data.dig('sys', 'country')
  end

  def city
    forecast_data.dig('name')
  end
end
