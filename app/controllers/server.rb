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
      #binding.pry
      raw_payload = JSON.parse(params[:payload], symbolize_names: true)
      # Check if client exists if it doesnt
      client = Client.find_by(identifier: identifier)
      unless client
        status 403
        body "#{identifier} not found. Cool story brah/gal."
      else
        PayloadParser.parse(raw_payload, identifier)
        # pr = PayloadRequest.new()
        # pr.save
        status 200
        body "Great success"
      end
    end
  end
end
