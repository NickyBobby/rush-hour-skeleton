class Event < ActiveRecord::Base
  validates :name, presence: true

  has_many :payload_requests
  def find_date_time
    payload_requests.map { |pr| DateTime.parse(pr.requested_at) }
  end

  def find_event_name
    payload_requests.map { |pr| pr.event }
  end

end
