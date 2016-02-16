module ViewFinder
  def self.get_client_stats(identifier)
    client = Client.find_by(identifier: identifier)
    return [:not_registered, {identifier: identifier}] unless client
    if client.payload_requests.empty?
      [:no_payloads, {identifier: identifier}]
    else
      [:stats, {stats: client.stats, client: client}]
    end
  end
end
