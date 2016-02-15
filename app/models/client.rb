require 'pry'

class Client < ActiveRecord::Base
  validates :identifier, presence: true
  validates :root_url, presence: true

  has_many :payload_requests
  has_many :urls, through: :payload_requests
  has_many :requests, through: :payload_requests
  has_many :resolutions, through: :payload_requests
  has_many :user_agents, through: :payload_requests

  def stats
    return {} if payload_requests.count == 0
    ({
      average_response_time: payload_requests.average_response_time,
      max_response_time: payload_requests.find_max_response_time,
      min_response_time: payload_requests.find_min_response_time,
      most_frequent_request: payload_requests.find_most_frequent_request_type,
      all_http_verbs: payload_requests.find_all_http_verbs.join(", "),
      requested_urls: payload_requests.return_ordered_list_of_urls,
      browsers: payload_requests.user_agent_browsers.join(", "),
      os: payload_requests.user_agent_os.join(", "),
      resolutions: payload_requests.requested_resolutions.join(", "),
      events: payload_requests.find_event_names
    })
  end

  def url_stats(relative_path)
    url = Url.find_by(address: "#{root_url}/#{relative_path}")
    return unless url
    ({
      max_response_time: url.find_max_response_time,
      min_response_time: url.find_min_response_time,
      average_response_time: url.find_average_response_time,
      response_times: url.list_response_times.join(", "),
      all_http_verbs: url.http_verbs.join(", "),
      top_three_referrers: url.most_popular_referrers.join(", "),
      top_three_user_agents: url.most_popular_useragents.join(", ")
    })
  end

  def event_stats(event_name)
    event = Event.find_by(name: "#{event_name}")
    return unless event
    ({
      times: event.find_date_time,
      event_names: event.find_event_name
      })

  end
end
