class OpenWeatherDecorator < Draper::Decorator
  attr_reader :forecast_data

  def initialize(forecast_data)
    @forecast_data = forecast_data
  end

  def decorate
    {
      country: forecast_data['sys']['country'],
      city: forecast_data['name'],
      country: forecast_data['sys']['country'],
      temp_min: formatted_temp(forecast_data['main']['temp_min']),
      temp_max: formatted_temp(forecast_data['main']['temp_max']),
      temp: formatted_temp(forecast_data['main']['temp']),
      humidity: forecast_data['main']['humidity'],
      pressure: forecast_data['main']['pressure'],
    }
  end

  def formatted_temp(temp)
    temp
  end
end
