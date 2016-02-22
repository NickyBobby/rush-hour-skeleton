require 'pry'

class Client < ActiveRecord::Base
  validates :identifier, presence: true
  validates :root_url, presence: true

  has_many :payload_requests
  has_many :urls, through: :payload_requests
  has_many :requests, through: :payload_requests
  has_many :resolutions, through: :payload_requests
  has_many :user_agents, through: :payload_requests
  has_many :events, through: :payload_requests

  def stats
    return [] if payload_requests.count == 0
    [
      ["Max response time (ms): ", payload_requests.find_max_response_time],
      ["Min response time (ms): ",payload_requests.find_min_response_time],
      ["Average response time (ms): ", payload_requests.average_response_time],
      ["Most frequent request type: ", payload_requests.find_most_frequent_request_type],
      ["All HTTP verbs used: ", payload_requests.find_all_http_verbs.join(", ")],
      ["Requested URLs: ", payload_requests.return_ordered_list_of_urls, "url", {relative_path: :relative_path, address: :address}],
      ["Event breakdown: ", payload_requests.find_event_names, "event", {relative_path: :name, address: :name}],
      ["Web browser breakdown: ", payload_requests.user_agent_browsers.join(", ")],
      ["OS breakdown: ", payload_requests.user_agent_os.join(", ")],
      ["Screen resolutions: ", payload_requests.requested_resolutions.join(", ")]
    ]
  end

  def url_stats(relative_path)
    url = Url.find_by(address: "#{root_url}/#{relative_path}")
    return unless url
    [
      ["Max response time (ms): ", url.find_max_response_time],
      ["Min response time (ms): ",url.find_min_response_time],
      ["Average response time (ms): ", url.find_average_response_time],
      ["All response times (ms): ", url.list_response_times.join(", ")],
      ["All HTTP verbs used: ", url.http_verbs.join(", ")],
      ["Top three most popular referrers: ", url.most_popular_referrers.join(", ")],
      ["Top three most popular user agents: ", url.most_popular_useragents.join(", ")]
    ]
  end

  def event_stats(event_name=nil)
    event = events.find_by(name: event_name)
    prs = PayloadRequest.where(event: event, client: self)

    return unless event
    [["Total 24 hour breakdown: ", prs.count]] + map_hours_to_bins(PayloadRequest.grouped_hours(prs))
  end

  def map_hours_to_bins(grouped_times)
    bins = []
    (0..23).each do |i|
      t1 = Time.parse("#{i}:00:00").strftime("%l %p")
      t2 = Time.parse("#{i+1}:00:00").strftime("%l %p")
      t1 = "Midnight" if i == 0
      t2 = "Midnight" if i == 23
      bins << ["Between #{t1} and #{t2}: ", grouped_times[i]]
    end
    bins
  end

end
