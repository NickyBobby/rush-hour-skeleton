class Url < ActiveRecord::Base
  validates :address, presence: true

  has_many :payload_requests

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
    sorted.map { |ref, prs| user_agent.address }.first(3)
  end
end
