require 'pry'

class Url < ActiveRecord::Base
  validates :address, presence: true

  has_many :payload_requests

  def relative_path
    address[/.\w+\/(.*)/]
    $1
  end

  def http_verbs
    gb = payload_requests.group_by {|pr| pr.request}
    sorted = gb.sort_by do |key, value|
      -1*value.length
    end
    sorted.map { |req, prs| req.verb }
  end

  def most_popular_referrers
    gb = payload_requests.group_by {|pr| pr.referrer}
    sorted = gb.sort_by do |key, value|
      -1*value.length
    end
    sorted.map { |ref, prs| ref.address }.first(3)
  end

  def most_popular_useragents
    gb = payload_requests.group_by {|pr| pr.user_agent}
    sorted = gb.sort_by do |key, value|
      -1*value.length
    end
    sorted.map { |ua, prs| "#{ua.platform} #{ua.browser}"}.first(3)
  end

  def find_max_response_time
    payload_requests.maximum(:responded_in)
  end

  def find_min_response_time
    payload_requests.minimum(:responded_in)
  end

  def list_response_times
    payload_requests.map { |pr| pr.responded_in }.sort.reverse
  end

  def find_average_response_time
    payload_requests.average(:responded_in).round(2)
  end

  def self.most_requests
    #.joins(:payload_requests).group("urls.address").count
    self.all.sort_by do |url|
      -1*url.payload_requests.count
    end
  end


end
