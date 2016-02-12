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

  def test_returns_list_of_URLs_from_most_frequent_to_least_frequent
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:url] = "www.google.com"
    rp3 = raw_payload
    rp3[:url] = "www.google.com"
    rp4 = raw_payload
    rp4[:url] = "www.turing.io"
    rp5 = raw_payload
    rp6 = raw_payload

    PayloadRequest.create(PayloadParser.parse(rp1))
    PayloadRequest.create(PayloadParser.parse(rp2))
    PayloadRequest.create(PayloadParser.parse(rp3))
    PayloadRequest.create(PayloadParser.parse(rp4))
    PayloadRequest.create(PayloadParser.parse(rp5))
    PayloadRequest.create(PayloadParser.parse(rp6))

    assert_equal ["http://jumpstartlab.com/blog", "www.google.com", "www.turing.io"], PayloadRequest.return_ordered_list_of_urls
  end

  def test_find_max_response_time_for_specific_URL
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:respondedIn] = 40
    rp2[:url] = "www.google.com"
    rp3 = raw_payload
    rp3[:respondedIn] = 50
    rp3[:url] = "www.google.com"
    rp4 = raw_payload
    rp4[:respondedIn] = 60
    rp5 = raw_payload
    rp5[:respondedIn] = 70
    rp6 = raw_payload
    rp6[:respondedIn] = 80

    PayloadRequest.create(PayloadParser.parse(rp1))
    PayloadRequest.create(PayloadParser.parse(rp2))
    PayloadRequest.create(PayloadParser.parse(rp3))
    PayloadRequest.create(PayloadParser.parse(rp4))
    PayloadRequest.create(PayloadParser.parse(rp5))
    PayloadRequest.create(PayloadParser.parse(rp6))
    url = Url.first
    url2 = Url.last

    assert_equal 80, url.find_max_response_time
    assert_equal 50, url2.find_max_response_time
  end

  def test_find_min_response_time_for_specific_URL
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:respondedIn] = 40
    rp2[:url] = "www.google.com"
    rp3 = raw_payload
    rp3[:respondedIn] = 50
    rp3[:url] = "www.google.com"
    rp4 = raw_payload
    rp4[:respondedIn] = 60
    rp5 = raw_payload
    rp5[:respondedIn] = 70
    rp6 = raw_payload
    rp6[:respondedIn] = 80

    PayloadRequest.create(PayloadParser.parse(rp1))
    PayloadRequest.create(PayloadParser.parse(rp2))
    PayloadRequest.create(PayloadParser.parse(rp3))
    PayloadRequest.create(PayloadParser.parse(rp4))
    PayloadRequest.create(PayloadParser.parse(rp5))
    PayloadRequest.create(PayloadParser.parse(rp6))
    url = Url.first
    url2 = Url.last
    assert_equal 37, url.find_min_response_time
    assert_equal 40, url2.find_min_response_time
  end

  def test_returns_list_of_response_times_for_specific_url
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:respondedIn] = 40
    rp2[:url] = "www.google.com"
    rp3 = raw_payload
    rp3[:respondedIn] = 50
    rp3[:url] = "www.google.com"
    rp4 = raw_payload
    rp4[:respondedIn] = 60
    rp5 = raw_payload
    rp5[:respondedIn] = 70
    rp6 = raw_payload
    rp6[:respondedIn] = 80

    PayloadRequest.create(PayloadParser.parse(rp1))
    PayloadRequest.create(PayloadParser.parse(rp2))
    PayloadRequest.create(PayloadParser.parse(rp3))
    PayloadRequest.create(PayloadParser.parse(rp4))
    PayloadRequest.create(PayloadParser.parse(rp5))
    PayloadRequest.create(PayloadParser.parse(rp6))
    url = Url.first
    url2 = Url.last

    assert_equal [80, 70, 60, 37], url.list_response_times
    assert_equal [50, 40], url2.list_response_times
  end

  def test_average_response_time_for_specific_url
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:respondedIn] = 40
    rp2[:url] = "www.google.com"
    rp3 = raw_payload
    rp3[:respondedIn] = 50
    rp3[:url] = "www.google.com"
    rp4 = raw_payload
    rp4[:respondedIn] = 60
    rp5 = raw_payload
    rp5[:respondedIn] = 70
    rp6 = raw_payload
    rp6[:respondedIn] = 80

    PayloadRequest.create(PayloadParser.parse(rp1))
    PayloadRequest.create(PayloadParser.parse(rp2))
    PayloadRequest.create(PayloadParser.parse(rp3))
    PayloadRequest.create(PayloadParser.parse(rp4))
    PayloadRequest.create(PayloadParser.parse(rp5))
    PayloadRequest.create(PayloadParser.parse(rp6))
    url = Url.first
    url2 = Url.last

    assert_equal 61.75, url.find_average_response_time
    assert_equal 45, url2.find_average_response_time
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
