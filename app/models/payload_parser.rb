require 'user_agent_parser'
class PayloadParser
  def self.parse(data)
  # def self.parse(data, identifier)
  # client = Client.find_by(identifier: identifier)
  binding.pry
    ua = UserAgentParser.parse(data[:userAgent])
    client_details = get_client_details(data[:url])
    ({
      url: Url.find_or_create_by(address: data[:url]),
      requested_at: data[:requestedAt],
      responded_in: data[:respondedIn],
      referrer: Referrer.find_or_create_by(address: data[:referredBy]),
      request: Request.find_or_create_by(verb: data[:requestType]),
      event: Event.find_or_create_by(name: data[:eventName]),
      user_agent: UserAgent.find_or_create_by(browser: ua.family, platform: ua.os.to_s),
      resolution: Resolution.find_or_create_by(width: data[:resolutionWidth], height: data[:resolutionHeight]),
      ip: Ip.find_or_create_by(address: data[:ip]),
      client: Client.find_or_create_by(identifier: client_details[0], root_url: client_details[1])
      # DELETE client: Client.find_or_create_by(identifier: client_details[0], root_url: client_details[1])
    })
    # client.payload_requests.create(details)
    # Payloads.create(data.merge(client_id: client.id))
  end

  def self.get_client_details(url)
    url = url[7..-1] if url.start_with?("http://")
    # www.somethign.gov/hiotherot
    root_url = url.split("/").first
    split_url = url.split(".")
    if split_url.length == 2
      identifier = split_url[0]
    else
      identifier = split_url[1]
    end
    [identifier, 'http://'+root_url]
  end
end
