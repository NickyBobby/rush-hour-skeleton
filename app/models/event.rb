class Event < ActiveRecord::Base
  validates :name, presence: true

  has_many :payload_requests
  def find_date_time
    payload_requests.map { |pr| DateTime.parse(pr.requested_at) }
  end

  def find_event_name
    name
  end

  def total_hits
    payload_requests.count
  end

  def grouped_hours
    grouped = {}
    (0..23).each { |i| grouped[i] = 0 }
    event_hours = payload_requests.map { |pr| Time.parse(pr.requested_at).hour }
    event_hours.each { |hour| grouped[hour] += 1 }
    grouped
  end

end
