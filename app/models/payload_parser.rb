require 'user_agent_parser'
class PayloadParser

  def self.parse(data, identifier)
    client = Client.find_by(identifier: identifier)
    pr = PayloadRequest.find_or_initialize_by(get_payload_details(data, client))
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

end
