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
    # binding.pry
    ({
      average_response_time: payload_requests.average_response_time,
      max_response_time: payload_requests.find_max_response_time,
      min_response_time: payload_requests.find_min_response_time,
      most_frequent_request: payload_requests.find_most_frequent_request_type,
      all_http_verbs: payload_requests.find_all_http_verbs.join(", "),
      requested_urls: payload_requests.return_ordered_list_of_urls.join(", "),
      browsers: payload_requests.user_agent_browsers.join(", "),
      os: payload_requests.user_agent_os.join(", "),
      resolutions: payload_requests.requested_resolutions.join(", ")
    })

  end
end
