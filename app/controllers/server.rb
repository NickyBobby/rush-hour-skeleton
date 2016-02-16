require 'pry'
require 'json'

module RushHour
  class Server < Sinatra::Base
    not_found do
      erb :error
    end

    post '/sources' do
      status_code, message = ClientGenerator.register_client(params)
      status(status_code)
      body(message)
    end

    post '/sources/:identifier/data' do |identifier|
      status_code, message = PayloadGenerator.register_payload(params, identifier)
      status(status_code)
      body(message)
    end

    get '/sources/:identifier' do |identifier|
      view, locals = ViewFinder.get_client_stats(identifier)
      erb view, locals: locals
    end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      @identifier = identifier
      @relative_path = relative_path
      @client = Client.find_by(identifier: identifier)
      @stats = @client.url_stats(relative_path)
      if @stats
        erb :url_stats
      else
        erb :no_url
      end
    end

    get '/sources/:identifier/events/:relative_path' do |identifier, relative_path|
      @identifier = identifier
      @relative_path = relative_path
      @client = Client.find_by(identifier: identifier)
      @stats = @client.event_stats(relative_path)
      @grouped = @stats[:hours]
      if @stats
        erb :event_stats
      else
        erb :no_event
      end
    end


  end
end
