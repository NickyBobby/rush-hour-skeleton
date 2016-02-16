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

  def self.get_url_stats(identifier, relative_path)
    client = Client.find_by(identifier: identifier)
    stats = client.url_stats(relative_path)
    if stats
      [:url_stats, {relative_path: relative_path, stats: stats, client: client}]
    else
      [:no_url, {relative_path: relative_path}]
    end
  end

  def self.get_event_stats(identifier, relative_path)
    client = Client.find_by(identifier: identifier)
    stats = client.event_stats(relative_path)
    if stats
      [:event_stats, {stats: stats, identifier: identifier}]
    else
      [:no_event, {relative_path: relative_path, identifier: identifier}]
    end
  end

end
