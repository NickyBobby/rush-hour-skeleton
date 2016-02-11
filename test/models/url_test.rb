require_relative '../test_helper'

class UrlTest < Minitest::Test
  include TestHelpers

  def test_url_can_instantiate_with_address
    ur = Url.new(address: "http://www.kazookid.com")
    assert ur.valid?
  end

  def test_url_needs_address_to_instantiate
    ur = Url.new()
    refute ur.valid?
  end

  def test_url_has_an_address
    ur = Url.create(address: "http://www.kazookid.com")
    assert_equal "http://www.kazookid.com", Url.all.first.address
  end


  def test_url_has_payload_requests
    ur = Url.new(address: "http://www.kazookid.com")
    assert_respond_to ur, :payload_requests
  end


  def test_url_returns_three_most_popular_http_verbs
    rp1 = raw_payload
    2.times do |n|
      rp1[:respondedIn] = 37+n
      PayloadRequest.create(PayloadParser.parse(rp1))
    end

    rp2 = raw_payload
    5.times do |n|
      rp2[:respondedIn] = 237+n
      rp2[:requestType] = "POST"
      PayloadRequest.create(PayloadParser.parse(rp2))
    end

    rp3 = raw_payload
    1.times do |n|
      rp3[:respondedIn] = 337+n
      rp3[:requestType] = "PUT"
      PayloadRequest.create(PayloadParser.parse(rp3))
    end

    rp4 = raw_payload
    10.times do |n|
      rp4[:respondedIn] = 437+n
      rp4[:requestType] = "DELETE"
      PayloadRequest.create(PayloadParser.parse(rp4))
    end
    assert_equal 1, Url.count
    url = Url.all.first
    assert_equal "http://jumpstartlab.com/blog", url.address
    assert_equal 18, url.payload_requests.count
    assert_equal ["DELETE", "POST", "GET", "PUT"], url.http_verbs
  end

  def test_url_returns_three_most_popular_referrers
    rp1 = raw_payload
    2.times do |n|
      rp1[:respondedIn] = 37+n
      PayloadRequest.create(PayloadParser.parse(rp1))
    end

    rp2 = raw_payload
    9.times do |n|
      rp2[:respondedIn] = 237+n
      rp2[:referredBy] = "http://google.com"
      PayloadRequest.create(PayloadParser.parse(rp2))
    end

    rp3 = raw_payload
    3.times do |n|
      rp3[:respondedIn] = 337+n
      rp3[:referredBy] = "http://youtube.com"
      PayloadRequest.create(PayloadParser.parse(rp3))
    end

    rp4 = raw_payload
    7.times do |n|
      rp4[:respondedIn] = 437+n
      rp4[:referredBy] = "http://netflix.com"
      PayloadRequest.create(PayloadParser.parse(rp4))
    end
    assert_equal 1, Url.count
    url = Url.all.first

    assert_equal ["http://google.com", "http://netflix.com", "http://youtube.com"], url.most_popular_referrers
  end

  def test_url_returns_three_most_popular_user_agents
    rp1 = raw_payload
    2.times do |n|
      rp1[:respondedIn] = 37+n
      PayloadRequest.create(PayloadParser.parse(rp1))
    end

    rp2 = raw_payload
    9.times do |n|
      rp2[:respondedIn] = 237+n
      rp2[:referredBy] = "http://google.com"
      PayloadRequest.create(PayloadParser.parse(rp2))
    end

    rp3 = raw_payload
    3.times do |n|
      rp3[:respondedIn] = 337+n
      rp3[:referredBy] = "http://youtube.com"
      PayloadRequest.create(PayloadParser.parse(rp3))
    end

    rp4 = raw_payload
    7.times do |n|
      rp4[:respondedIn] = 437+n
      rp4[:referredBy] = "http://netflix.com"
      PayloadRequest.create(PayloadParser.parse(rp4))
    end
    assert_equal 1, Url.count
    url = Url.all.first

    assert_equal ["http://google.com", "http://netflix.com", "http://youtube.com"], url.most_popular_referrers
  end


end
