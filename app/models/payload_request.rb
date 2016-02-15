require 'pry'
class PayloadRequest < ActiveRecord::Base
  validates :url_id, presence: true
  validates :requested_at, presence: true
  validates :responded_in, presence: true
  validates :referrer_id, presence: true
  validates :request_id, presence: true
  validates :event_id, presence: true
  validates :user_agent_id, presence: true
  validates :resolution_id, presence: true
  validates :ip_id, presence: true
  validates :client_id, presence: true
  validates :payload_sha, presence: true, uniqueness: true

  belongs_to :referrer
  belongs_to :request
  belongs_to :event
  belongs_to :user_agent
  belongs_to :resolution
  belongs_to :url
  belongs_to :ip
  belongs_to :client

  def self.average_response_time
    self.average(:responded_in).round(2)
  end

  def self.find_max_response_time
    self.maximum(:responded_in)
  end

  def self.find_min_response_time
    self.minimum(:responded_in)
  end

  def self.find_most_frequent_request_type
    id = self.group(:request_id).order('count(*) DESC').pluck(:request_id).first
    r = Request.find(id)
    r.verb
  end

  def self.find_all_http_verbs
    request_ids = self.group(:request_id).order('count(*) DESC').pluck(:request_id)
    request_ids.map { |id| Request.find(id).verb }
  end

  def self.return_ordered_list_of_urls
    #joins(:url).group("urls.address").order('count(*) DESC').count
    url_ids = self.group(:url_id).order('count(*) DESC').pluck(:url_id)
    url_ids.map { |id| Url.find(id) }

  end

  def self.ranked_events
    event_ids = self.group(:event_id).order('count(*)').pluck(:event_id).reverse
    event_ids.map { |id| Event.find(id).name }
  end

  def self.requested_resolutions
    resolution_ids = self.group(:resolution_id).order(:resolution_id).pluck(:resolution_id)
    resolution_ids.map do |id|
      res = Resolution.find(id)
      "#{res.width} x #{res.height}"
    end
  end

  def self.user_agent_browsers
    user_agent_ids = self.group(:user_agent_id).order(:user_agent_id).pluck(:user_agent_id)
    user_agent_ids.map do |id|
      ua = UserAgent.find(id)
      "#{ua.browser}"
    end
  end

  def self.user_agent_os
    user_agent_ids = self.group(:user_agent_id).order(:user_agent_id).pluck(:user_agent_id)
    user_agent_ids.map do |id|
      ua = UserAgent.find(id)
      "#{ua.platform}"
    end
  end

  def self.find_event_names
    event_name_ids = self.group(:event_id).order('count(*)').pluck(:event_id)
    event_name_ids.map { |id| Event.find(id) }
  end

end
