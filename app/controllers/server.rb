require 'pry'
require 'json'

module RushHour
  class Server < Sinatra::Base
    not_found do
      erb :error
    end

    post '/sources' do
      client = Client.new(identifier: params["identifier"], root_url: params["rootUrl"])
      if client.save
        status 200
        body JSON.generate({:identifier => "#{client.identifier}"})
      else
        status 400
        body "SO MUCH FAIL"
      end
    end
  end
end
