class WeatherController < ApplicationController

  def index
    @forecast = WeatherForecastService.new(weather_params).call if weather_params.present?
    render :index
  end

  private

  def weather_params
    params[:search]
  end
end
