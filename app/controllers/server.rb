require 'pry'
require 'json'

module RushHour
  class Server < Sinatra::Base
    not_found do
      erb :error
    end

    post '/sources' do
      client = Client.find_or_initialize_by(identifier: params["identifier"], root_url: params["rootUrl"])

      if !client.id && client.valid?
        client.save
        status 200
        body JSON.generate({:identifier => "#{client.identifier}"})
      elsif client.id
        status 403
        body "Identifier already exists brah/gal."
      else
        messages = client.errors.messages
        status 400
        body "Error: #{messages}"
      end

      # status, body = ClientGenerator.new.method(params)
      # status(status)
      # body(body)
    end

    post '/sources/:identifier/data' do |identifier|
      raw_payload = JSON.parse(params[:payload], symbolize_names: true)
      client = Client.find_by(identifier: identifier)
      if !client
        status 403
        body "#{identifier} not found. Cool story brah/gal."
      elsif PayloadRequest.find_by(PayloadParser.get_payload_details(raw_payload, client))# false if we have seen this payload request before
        status 403
        body "Error: Payload Request already received"
      elsif errors = PayloadParser.parse(raw_payload, identifier)
        status 400
        body "Error: "
      else
        status 200
        body "Great success"
      end
    end

    get '/sources/:identifier' do |identifier|
      @client = Client.find_by(identifier: identifier)
      @client_identifier = identifier
      if @client && !@client.payload_requests.empty?
        @stats = @client.stats
        # binding.pry
        erb :stats
      elsif @client && @client.payload_requests.empty?
        erb :no_payloads
      else
        erb :not_registered
      end
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

    get '/sources/:identifier/events' do |identifier|
      @client = Client.find_by(identifier: identifier)
      @stats = @client.stats
      erb :event_index
    end

    get '/sources/:identifier/events/:relative_path' do |identifier, relative_path|
      @identifier = identifier
      @relative_path = relative_path
      @client = Client.find_by(identifier: identifier)
      @stats = @client.event_stats(relative_path)
      # binding.pry
      if @stats
        @grouped = @stats[:hours]
        erb :event_stats
      else
        erb :no_event
      end
    end

  end
end
