class WeatherController < ApplicationController
  require 'sms_helper'

  before_action :authenticate_user!, only: [:index, :create]
  #devis is important
  @@query_api = "http://api.openweathermap.org/data/2.5/forecast/city?id="
  @@city_code = "5128581" #new york
  @@query_forecast_api = "http://api.openweathermap.org/data/2.5/forecast/daily?id="

  SmsHelper.quick_send(@@city_code, 5104097763)

  def farenheit(kelvin)
    ( kelvin - 273.15 )*9/5+32
  end

  def api_access_url
    @@query_api + @@city_code + "&APPID=" + Rails.application.secrets.open_weather_map.to_s
  end

  def api_forecast_url
    url = @@query_forecast_api + @@city_code + "&cnt=10&mode=json" + "&APPID=" + Rails.application.secrets.open_weather_map.to_s
  end

  def current_icon(url)
    response = JSON.load( RestClient.get url )
    icon = response['list'][0]['weather'] # reads as Hash, Array, now you know you have to loop thorough all  the arrays'! damn, you need a loop here... take a deep breath...
    icon.map do |e|
      { title:  e['description'] }
    end
  end

  def get_current(url)
    response = JSON.load( RestClient.get url )
    city = response['city']['name']
    kelvin = response['list'][0]['main']['temp']
    wind = response['list'][0]['wind']['speed']
    icon = response['list'][0]['weather']

    farenheit = ( kelvin - 273.15 )*9/5+32
    data = { :city => city, :farenheit => farenheit, :wind => wind, :icon => icon }
  end

  def get_forecast(url)
    response = JSON.load( RestClient.get url )
    future = response['cnt']

    dailys = []
    response['list'].each do |day|
      dailys.push('Day' => (day['temp']['day']).to_i)
    end
    icon = []
    response['list'].each do |day|
      icon.push('Icon' => (day['weather'][0]['main']).to_s)
    end
    dailys
    # temp_day = response['cnt']
    # temp_max = response['cnt']
    # weather_desc = response['cnt']
    data = { :days => future, :temp_basic => dailys, :icon => icon }
  end

  def get_forecast_date(url)
    response = JSON.load( RestClient.get url )
    response['list'].map do |v|
     v['dt']
    end
  end

  def index
    @key_check = [api_access_url, api_forecast_url]
    @weather = Weather.get_current( api_access_url )
    @forecast = get_forecast( api_forecast_url )
    @castdate = get_forecast_date( api_forecast_url )
    @current_icon = current_icon( api_access_url )
    #@farenheit = farenheit
    # @weathers = weather.search_for(params[:q])
    # go into the models and rails.rb in order to allow the .search_for method to be available in a sort of whitelisted way
  end
end