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
      weather_icon: forecast_data['weather'][0]['icon_uri'],
      temp_min: forecast_data['main']['temp_min'],
      temp_max: forecast_data['main']['temp_max'],
      temp: forecast_data['main']['temp'],
      humidity: forecast_data['main']['humidity'],
      cached: false
    }
  end
end


# {"coord"=>{"lon"=>73.7626, "lat"=>18.6032},
#  "weather"=>[{"icon_uri"=>#<URI::HTTP http://openweathermap.org/img/wn/01n@2x.png>, "icon"=>"01n", "id"=>800, "main"=>"Clear", "description"=>"clear sky"}],
#  "base"=>"stations",
#  "main"=>{"temp"=>296.45, "feels_like"=>295.78, "temp_min"=>296.45, "temp_max"=>296.45, "pressure"=>1014, "humidity"=>36, "sea_level"=>1014, "grnd_level"=>950},
#  "visibility"=>10000,
#  "wind"=>{"speed"=>1.71, "deg"=>333},
#  "clouds"=>{"all"=>2},
#  "dt"=>2024-03-07 19:15:15 UTC,
#  "sys"=>{"country"=>"IN", "sunrise"=>2024-03-08 01:18:47 UTC, "sunset"=>2024-03-08 13:12:53 UTC},
#  "timezone"=>19800,
#  "id"=>0,
#  "name"=>"Wakad",
#  "cod"=>200}
