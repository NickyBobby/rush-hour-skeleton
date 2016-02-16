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
      view, locals = ViewFinder.get_url_stats(identifier, relative_path)
      erb view, locals: locals
    end

    get '/sources/:identifier/events/:relative_path' do |identifier, relative_path|
      view, locals = ViewFinder.get_event_stats(identifier, relative_path)
      erb view, locals: locals
    end

  end
end
