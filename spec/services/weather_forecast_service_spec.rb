# spec/services/weather_forecast_service_spec.rb

require 'rails_helper'

RSpec.describe WeatherForecastService, type: :service do
  let(:zip_code) { '12345' }
  let(:decorator_double) { instance_double(OpenWeatherDecorator, decorate: { 'temperature' => 25, 'humidity' => 60, 'cached' => true }) }

  before do
    Rails.application.config.weather_provider = 'open_weather'
  end

  describe '#call' do
    subject(:service_call) { described_class.new({ zip_code: zip_code }).call }

    context 'when forecast is in the cache' do
      let(:cached_data) { { 'temp' => 280.17, 'humidity' => 90, 'cached' => true } }

      before do
        allow(Rails.cache).to receive(:read).and_return(cached_data)
        allow(OpenWeatherDecorator).to receive(:new).and_return(decorator_double)
      end

      it 'returns decorated cached forecast data' do
        expect(service_call).to eq({ 'temperature' => 25, 'humidity' => 60, 'cached' => true })
      end

      it 'does not fetch data from the provider' do
        expect_any_instance_of(WeatherProviders::OpenWeather).not_to receive(:get_data)
        service_call
      end

      it 'does not save to cache' do
        expect(Rails.cache).not_to receive(:write)
        service_call
      end
    end

    context 'when forecast is not in the cache' do
      let(:provider_data) { { 'temp' => 280.17, 'humidity' => 90, 'cached' => false } }

      before do
        allow_any_instance_of(WeatherProviders::OpenWeather).to receive(:get_data).and_return(provider_data)
        allow(OpenWeatherDecorator).to receive(:new).and_return(decorator_double)
      end

      it 'fetches data from the provider and saves to cache' do
        expect(Rails.cache).to receive(:write).with(zip_code, provider_data, expires_in: 30.minutes)
        expect(service_call).to eq({ 'temperature' => 25, 'humidity' => 60, 'cached' => true })
      end

      it 'sets is_cached_forecast to false' do
        service_call
        expect(service_call.instance_variable_get(:@is_cached_forecast)).to be_falsey
      end
    end

    context 'when unable to fetch weather data' do
      before do
        allow_any_instance_of(WeatherProviders::OpenWeather).to receive(:get_data).and_return(nil)
      end

      it 'returns an error message' do
        expect(service_call).to eq({ 'error': 'Unable to fetch weather data.' })
      end
    end
  end
end
