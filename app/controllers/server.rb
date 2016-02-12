require 'pry'

module RushHour
  class Server < Sinatra::Base
    not_found do
      erb :error
    end

    post '/sources' do
      #create a Client
      # send back the response
    end
  end
end
