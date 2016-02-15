require 'digest'

class PayloadParser

  def self.parse(data, identifier)
    client = Client.find_by(identifier: identifier)
    details = get_payload_details(data, client)
    pr = PayloadRequest.find_or_initialize_by(details)
    pr.payload_sha = payload_sha(pr)
    pr.save
    pr.errors unless pr.valid?
  end

  def self.get_payload_details(data, client)
    browser, platform = parse_user_agent(data)
    ({
      url: Url.find_or_create_by(address: data[:url]),
      requested_at: data[:requestedAt],
      responded_in: data[:respondedIn],
      referrer: Referrer.find_or_create_by(address: data[:referredBy]),
      request: Request.find_or_create_by(verb: data[:requestType]),
      event: Event.find_or_create_by(name: data[:eventName]),
      user_agent: UserAgent.find_or_create_by(browser: browser, platform: platform),
      resolution: Resolution.find_or_create_by(width: data[:resolutionWidth], height: data[:resolutionHeight]),
      ip: Ip.find_or_create_by(address: data[:ip]),
      client: client
    })
  end

  def self.parse_user_agent(data)
    browser = nil
    platform = nil
    if data[:userAgent] && !data[:userAgent].empty?
      ua = UserAgentParser.parse(data[:userAgent])
      browser = ua.family
      platform = ua.os.to_s
    end
    [browser, platform]
  end

  def self.payload_sha(pr)
    payload = "#{pr.url_id}#{pr.requested_at}#{pr.responded_in}#{pr.referrer_id}#{pr.request_id}#{pr.event_id}#{pr.user_agent_id}#{pr.resolution_id}#{pr.ip_id}#{pr.client_id}"
    Digest::SHA256.hexdigest(payload)
  end

end
