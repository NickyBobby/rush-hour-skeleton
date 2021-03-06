ENV["RACK_ENV"] ||= "test"

require 'bundler'
Bundler.require

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'capybara/dsl'
require 'tilt/erb'
require 'database_cleaner'
require 'json'

DatabaseCleaner.strategy = :truncation, {except: %w[public.schema_migrations]}

module TestHelpers
  include Rack::Test::Methods
  def app
    RushHour::Server
  end

  def setup
    DatabaseCleaner.start
    super
  end

  def teardown
    DatabaseCleaner.clean
    super
  end

  def raw_payload(identifier="jumpstartlab")
    Client.find_or_create_by(identifier: identifier, root_url: "http://www.#{identifier}.com")
    ({
      "url":"http://#{identifier}.com/blog",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":37,
      "referredBy":"http://#{identifier}.com",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
    })
  end

  def load_payload_requests(identifier = "jumpstartlab", data = {})
    data.each do |key, values|
      values.each do |value|
        rp = raw_payload(identifier)
        if key == :resolution
          rp[:resolutionWidth] = value[0]
          rp[:resolutionHeight] = value[1]
        else
          rp[key] = value
        end
        PayloadParser.parse(rp, identifier)
      end
    end
  end

  def create_n_requests(n, identifier, data = {})
    if data.keys.include?(:eventName)
      varkey = :ip
    else
      varkey = :eventName
    end

    n.times do |i|
      rp = raw_payload(identifier)
      data.each do |key, value|
        if key == :resolution
          rp[:resolutionWidth] = value[0]
          rp[:resolutionHeight] = value[1]
        else
          rp[key] = value
        end
      end
      rp[varkey] = "Making request unique: #{i}"
      PayloadParser.parse(rp, identifier)
    end
  end

  def load_default_request(identifier)
    PayloadParser.parse(raw_payload(identifier), identifier)
  end
end

Capybara.app = RushHour::Server
Capybara.save_and_open_page_path = 'tmp/capybara'

class FeatureTest < Minitest::Test
  include Capybara::DSL
  include TestHelpers
end
