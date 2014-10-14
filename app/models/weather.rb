class Weather < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable


  def self.farenheit(kelvin)
    ( kelvin - 273.15 )*9/5+32
  end

  def self.api_access_url
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

  def self.get_current(url)


    @@query_api = "http://api.openweathermap.org/data/2.5/forecast/city?id="
    @@city_code = "5128581" #new york
    @@query_forecast_api = "http://api.openweathermap.org/data/2.5/forecast/daily?id="

    url = @@query_api + @@city_code + "&APPID=" + Rails.application.secrets.open_weather_map.to_s

    @url = url


    response = JSON.load( RestClient.get url )
    city = response['city']['name']
    kelvin = response['list'][0]['main']['temp']
    wind = response['list'][0]['wind']['speed']
    icon = response['list'][0]['weather']

    farenheit = ( kelvin - 273.15 )*9/5+32
    data = { :city => city, :farenheit => farenheit, :wind => wind, :icon => icon }
  end

  def self.get_forecast(url)
    url = @@query_api + @@city_code + "&APPID=" + Rails.application.secrets.open_weather_map.to_s

    @url = url

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
end
