require 'user_agent_parser'
class PayloadParser
  def self.parse(data, identifier = "google")
  # def self.parse(data, identifier)
    client = Client.find_by(identifier: identifier)
    if data[:userAgent] && !data[:userAgent].empty?
      ua = UserAgentParser.parse(data[:userAgent])
      browser = ua.family
      platform = ua.os.to_s
    else
      browser = nil
      platform = nil
    end
    details = ({
      url: Url.find_or_create_by(address: data[:url]),
      requested_at: data[:requestedAt],
      responded_in: data[:respondedIn],
      referrer: Referrer.find_or_create_by(address: data[:referredBy]),
      request: Request.find_or_create_by(verb: data[:requestType]),
      event: Event.find_or_create_by(name: data[:eventName]),
      user_agent: UserAgent.find_or_create_by(browser: browser , platform: platform),
      resolution: Resolution.find_or_create_by(width: data[:resolutionWidth], height: data[:resolutionHeight]),
      ip: Ip.find_or_create_by(address: data[:ip]),
      # client: Client.find_or_create_by(identifier: client_details[0], root_url: client_details[1])
      # DELETE client: Client.find_or_create_by(identifier: client_details[0], root_url: client_details[1])
    })
    pr = PayloadRequest.new(details.merge(client_id: client.id))
    # binding.pry

    pr.save
    unless pr.valid?
      pr.errors
    end
  end

  def self.get_payload_details(data, client)
    if data[:userAgent] && !data[:userAgent].empty?
      ua = UserAgentParser.parse(data[:userAgent])
      browser = ua.family
      platform = ua.os.to_s
    else
      browser = nil
      platform = nil
    end
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
  # def self.get_client_details(url)
  #   binding.pry
  #   url = url[7..-1] if url.start_with?("http://")
  #   # http://www.somethign.gov/hiotherot
  #   root_url = url.split("/").first
  #   split_url = url.split(".")
  #   if split_url.length == 2
  #     identifier = split_url[0]
  #   else
  #     identifier = split_url[1]
  #   end
  #   [identifier, 'http://'+root_url]
  # end
end
