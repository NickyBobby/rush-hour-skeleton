module ClientGenerator

  def self.register_client(params)

    client = Client.find_by(identifier: params[:identifier])
    return [403, "Identifier already exists brah/gal."] if client

    client = Client.new(identifier: params[:identifier], root_url: params[:rootUrl])


    if client.save
      [200, JSON.generate({identifier: "#{client.identifier}"})]
    else
      messages = client.errors.messages
      key = messages.keys.first
      [400,"Error: #{key} #{messages[key].first}"]
    end
  end
  
end
