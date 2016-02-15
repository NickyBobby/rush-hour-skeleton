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
    assert_equal "http://www.kazookid.com", Url.first.address
  end


  def test_url_has_payload_requests
    ur = Url.new(address: "http://www.kazookid.com")
    assert_respond_to ur, :payload_requests
  end

  def test_url_can_parse_relative_paths
    ur = Url.new(address: "http://nickrinna.com/giphys")
    assert_equal "giphys", ur.relative_path
    ur = Url.new(address: "http://www.reddit.com/r/dinosaurs")
    assert_equal "r/dinosaurs", ur.relative_path
    ur = Url.new(address: "http://www.turing.io/people")
    assert_equal "people", ur.relative_path
    ur = Url.new(address: "http://nickrinna.com")
    assert_nil ur.relative_path
  end

  def test_returns_list_of_URLs_from_most_frequent_to_least_frequent
    rp1 = raw_payload
    rp2 = raw_payload("google")
    rp2[:url] = "www.google.com"
    rp3 = raw_payload("google")
    rp3[:url] = "www.google.com"
    rp4 = raw_payload("turing")
    rp4[:url] = "www.turing.io"
    rp5 = raw_payload
    rp6 = raw_payload

    PayloadParser.parse(rp1, "jumpstartlab")
    PayloadParser.parse(rp2, "google")
    PayloadParser.parse(rp3, "google")
    PayloadParser.parse(rp4, "turing")
    PayloadParser.parse(rp5, "jumpstartlab")
    PayloadParser.parse(rp6, "jumpstartlab")

    assert_equal [Url.find_by(address: "http://jumpstartlab.com/blog"),
                  Url.find_by(address: "www.google.com"),
                  Url.find_by(address: "www.turing.io")],
                  PayloadRequest.return_ordered_list_of_urls
  end

  def test_find_max_response_time_for_specific_URL
    rp1 = raw_payload
    rp2 = raw_payload("google")
    rp2[:respondedIn] = 40
    rp3 = raw_payload("google")
    rp3[:respondedIn] = 50
    rp4 = raw_payload
    rp4[:respondedIn] = 60
    rp5 = raw_payload
    rp5[:respondedIn] = 70
    rp6 = raw_payload
    rp6[:respondedIn] = 80

    PayloadParser.parse(rp1, "jumpstartlab")
    PayloadParser.parse(rp2, "google")
    PayloadParser.parse(rp3, "google")
    PayloadParser.parse(rp4, "jumpstartlab")
    PayloadParser.parse(rp5, "jumpstartlab")
    PayloadParser.parse(rp6, "jumpstartlab")
    url = Url.first
    url2 = Url.last

    assert_equal 80, url.find_max_response_time
    assert_equal 50, url2.find_max_response_time
  end

  def test_find_min_response_time_for_specific_URL
    rp1 = raw_payload
    rp2 = raw_payload("google")
    rp2[:respondedIn] = 40
    rp3 = raw_payload("google")
    rp3[:respondedIn] = 50
    rp4 = raw_payload
    rp4[:respondedIn] = 60
    rp5 = raw_payload
    rp5[:respondedIn] = 70
    rp6 = raw_payload
    rp6[:respondedIn] = 80

    PayloadParser.parse(rp1, "jumpstartlab")
    PayloadParser.parse(rp2, "google")
    PayloadParser.parse(rp3, "google")
    PayloadParser.parse(rp4, "jumpstartlab")
    PayloadParser.parse(rp5, "jumpstartlab")
    PayloadParser.parse(rp6, "jumpstartlab")
    url = Url.first
    url2 = Url.last

    assert_equal 37, url.find_min_response_time
    assert_equal 40, url2.find_min_response_time
  end

  def test_returns_list_of_response_times_for_specific_url
    rp1 = raw_payload
    rp2 = raw_payload("google")
    rp2[:respondedIn] = 40
    rp3 = raw_payload("google")
    rp3[:respondedIn] = 50
    rp4 = raw_payload
    rp4[:respondedIn] = 60
    rp5 = raw_payload
    rp5[:respondedIn] = 70
    rp6 = raw_payload
    rp6[:respondedIn] = 80

    PayloadParser.parse(rp1, "jumpstartlab")
    PayloadParser.parse(rp2, "google")
    PayloadParser.parse(rp3, "google")
    PayloadParser.parse(rp4, "jumpstartlab")
    PayloadParser.parse(rp5, "jumpstartlab")
    PayloadParser.parse(rp6, "jumpstartlab")
    url = Url.first
    url2 = Url.last

    assert_equal [80, 70, 60, 37], url.list_response_times
    assert_equal [50, 40], url2.list_response_times
  end

  def test_average_response_time_for_specific_url
    rp1 = raw_payload
    rp2 = raw_payload("google")
    rp2[:respondedIn] = 40
    rp3 = raw_payload("google")
    rp3[:respondedIn] = 50
    rp4 = raw_payload
    rp4[:respondedIn] = 60
    rp5 = raw_payload
    rp5[:respondedIn] = 70
    rp6 = raw_payload
    rp6[:respondedIn] = 80

    PayloadParser.parse(rp1, "jumpstartlab")
    PayloadParser.parse(rp2, "google")
    PayloadParser.parse(rp3, "google")
    PayloadParser.parse(rp4, "jumpstartlab")
    PayloadParser.parse(rp5, "jumpstartlab")
    PayloadParser.parse(rp6, "jumpstartlab")
    url = Url.first
    url2 = Url.last

    assert_equal 61.75, url.find_average_response_time
    assert_equal 45, url2.find_average_response_time
  end


  def test_url_returns_three_most_popular_http_verbs
    rp1 = raw_payload
    2.times do |n|
      rp1[:respondedIn] = 37+n
      PayloadParser.parse(rp1, "jumpstartlab")
    end

    rp2 = raw_payload
    5.times do |n|
      rp2[:respondedIn] = 237+n
      rp2[:requestType] = "POST"
      PayloadParser.parse(rp2, "jumpstartlab")
    end

    rp3 = raw_payload
    1.times do |n|
      rp3[:respondedIn] = 337+n
      rp3[:requestType] = "PUT"
      PayloadParser.parse(rp3, "jumpstartlab")
    end

    rp4 = raw_payload
    10.times do |n|
      rp4[:respondedIn] = 437+n
      rp4[:requestType] = "DELETE"
      PayloadParser.parse(rp4, "jumpstartlab")
    end
    assert_equal 1, Url.count
    url = Url.first
    assert_equal "http://jumpstartlab.com/blog", url.address
    assert_equal 18, url.payload_requests.count
    assert_equal ["DELETE", "POST", "GET", "PUT"], url.http_verbs
  end

  def test_url_returns_three_most_popular_referrers
    rp1 = raw_payload
    2.times do |n|
      rp1[:respondedIn] = 37+n
      PayloadParser.parse(rp1, "jumpstartlab")
    end

    rp2 = raw_payload
    9.times do |n|
      rp2[:respondedIn] = 237+n
      rp2[:referredBy] = "http://google.com"
      PayloadParser.parse(rp2, "jumpstartlab")
    end

    rp3 = raw_payload
    3.times do |n|
      rp3[:respondedIn] = 337+n
      rp3[:referredBy] = "http://youtube.com"
      PayloadParser.parse(rp3, "jumpstartlab")
    end

    rp4 = raw_payload
    7.times do |n|
      rp4[:respondedIn] = 437+n
      rp4[:referredBy] = "http://netflix.com"
      PayloadParser.parse(rp4, "jumpstartlab")
    end
    assert_equal 1, Url.count
    url = Url.first

    assert_equal 21, PayloadRequest.count
    assert_equal 1, Client.count
    assert_equal ["http://google.com", "http://netflix.com", "http://youtube.com"], url.most_popular_referrers
  end

  def test_url_returns_three_most_popular_user_agents
    rp1 = raw_payload
    2.times do |n|
      rp1[:respondedIn] = 37+n
      PayloadParser.parse(rp1, "jumpstartlab")
    end

    rp2 = raw_payload
    9.times do |n|
      rp2[:respondedIn] = 237+n
      rp2[:userAgent] = "Mozilla/5.0 (X11; Linux i586; rv:31.0) Gecko/20100101 Firefox/31.0"
      PayloadParser.parse(rp2, "jumpstartlab")
    end

    rp3 = raw_payload
    3.times do |n|
      rp3[:respondedIn] = 337+n
      rp3[:userAgent] = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)"
      PayloadParser.parse(rp3, "jumpstartlab")
    end

    rp4 = raw_payload
    7.times do |n|
      rp4[:respondedIn] = 437+n
      rp4[:userAgent] = "Mozilla/5.0 (PLAYSTATION 3; 1.10)"
      PayloadParser.parse(rp4, "jumpstartlab")
    end
    assert_equal 1, Url.count
    url = Url.first

    assert_equal ["Linux Firefox", "Other NetFront", "Windows 7 IE"], url.most_popular_useragents
  end


end
