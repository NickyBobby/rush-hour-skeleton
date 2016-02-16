class PayloadGenerator

  def self.register_payload(params, identifier)
    client = Client.find_by(identifier: identifier)
    return [403, "#{identifier} not found. Cool story brah/gal."] unless client

    data = JSON.parse(params[:payload], symbolize_names: true)
    pr = PayloadRequest.find_by(payload_sha: PayloadParser.payload_sha(data, identifier))
    return [403, "Error: Payload Request already received"] if pr

    if errors = PayloadParser.parse(data, identifier)
      messages = errors.messages
      key = messages.keys.first
      [400, "Error: #{key} #{messages[key].first}"]
    else
      [200, "Great success"]
    end
  end
end
