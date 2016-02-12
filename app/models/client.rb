class Client < ActiveRecord::Base
  validates :identifier, presence: true
  validates :root_url, presence: true

  has_many :payload_requests
  has_many :urls, through: :payload_requests
  has_many :requests, through: :payload_requests
  has_many :resolutions, through: :payload_requests
  has_many :user_agents, through: :payload_requests
end
