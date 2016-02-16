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
    (0..23).each do |i|
      grouped[i] = 0
    end
    event_hours = payload_requests.map { |pr| Time.parse(pr.requested_at).hour }
    event_hours.each do |hour|
      grouped[hour]+=1
    end
    grouped
  end

end
