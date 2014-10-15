class NewsController < ApplicationController
  require 'sms_helper'


  def get_from(url)
    response = JSON.load( RestClient.get url )
    puts response.class

    puts response['new'].class # reads as Hash, Array, now you know you have to loop thorough all  the arrays'! damn, you need a loop here... take a deep breath...

      response['new'].map do |things|
        story = {
            title:  things['title'],
         #   category: things['content']['plain']
        }

    end
  end


  def index
    @mashable = get_from( "mashable.com/stories.json" )
    SmsHelper.quick_send(@mashable, 5104097763)
    # @weathers = weather.search_for(params[:q])
    # go into the models and rails.rb in order to allow the .search_for method to be available in a sort of whitelisted way
  end

  def new
    @weather = Weather.new
  end

  def show
    load
  end

  def edit
    load
  end

  def update
    @weather.update safe_painting_params
    redirect_to @weather
  end

  def destroy
    @weather.delete
  end

  def create
    #rails 3 way      @weather = weather.create(params[:painting])
    @weather = Weather.create(safe_painting_params) #create initialisases and saves to the database
    if @weather.save
      redirect_to @weather
    else
      #fail
      #   redirect_to weathers_path
      render 'new'
    end
  end

  private

  def safe_weather_params
    params.require('weather').permit(:name)
  end

  def load
    @weather = weather.find(params[:id])
  end




end
