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
        binding.pry
        status 403
        body "Identifier already exists brah/gal."
      else
        messages = client.errors.messages
        status 400
        body "Error: #{messages}"
      end
    end
  end
end
