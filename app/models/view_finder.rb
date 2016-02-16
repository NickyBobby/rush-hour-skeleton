module ViewFinder
  def self.get_client_stats(identifier)
    client = Client.find_by(identifier: identifier)
    return [:not_registered, {identifier: identifier}] unless client
    if client.payload_requests.empty?
      [:no_payloads, {identifier: identifier}]
    else
      [:stats, {stats: client.stats, identifier: identifier}]
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

  def self.get_event_stats(identifier, event_name)
    client = Client.find_by(identifier: identifier)
    stats = client.event_stats(event_name)
    if stats
      [:event_stats, {stats: stats, identifier: identifier, event_name: event_name}]
    else
      [:no_event, {relative_path: event_name, identifier: identifier}]
    end
  end

  def self.get_events(identifier)
    client = Client.find_by(identifier: identifier)
    return [:not_registered, {identifier: identifier}] unless client
    [:event_index, {events: client.events, identifier: identifier}]
  end

end
