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
    create_n_requests(6, "jumpstartlab", url: "http://jumpstartlab.com/blog")
    create_n_requests(3, "google", url: "www.google.com")
    create_n_requests(2, "turing", url: "www.turing.io")

    assert_equal [Url.find_by(address: "http://jumpstartlab.com/blog"),
                  Url.find_by(address: "www.google.com"),
                  Url.find_by(address: "www.turing.io")],
                  PayloadRequest.return_ordered_list_of_urls
  end

  def test_find_max_response_time_for_specific_URL
    load_default_request("jumpstartlab")
    load_payload_requests("google", respondedIn: [40, 50])
    load_payload_requests("jumpstartlab", respondedIn: [60, 80, 70])

    url = Url.first
    url2 = Url.last

    assert_equal 80, url.find_max_response_time
    assert_equal 50, url2.find_max_response_time
  end

  def test_find_min_response_time_for_specific_URL
    load_default_request("jumpstartlab")
    load_payload_requests("google", respondedIn: [40, 50])
    load_payload_requests("jumpstartlab", respondedIn: [60, 80, 70])

    url = Url.first
    url2 = Url.last

    assert_equal 37, url.find_min_response_time
    assert_equal 40, url2.find_min_response_time
  end

  def test_returns_list_of_response_times_for_specific_url
    load_default_request("jumpstartlab")
    load_payload_requests("google", respondedIn: [40, 50])
    load_payload_requests("jumpstartlab", respondedIn: [60, 80, 70])

    url = Url.first
    url2 = Url.last

    assert_equal [80, 70, 60, 37], url.list_response_times
    assert_equal [50, 40], url2.list_response_times
  end

  def test_average_response_time_for_specific_url
    load_default_request("jumpstartlab")
    load_payload_requests("google", respondedIn: [40, 50])
    load_payload_requests("jumpstartlab", respondedIn: [60, 80, 70])

    url = Url.first
    url2 = Url.last

    assert_equal 61.75, url.find_average_response_time
    assert_equal 45, url2.find_average_response_time
  end


  def test_url_returns_three_most_popular_http_verbs
    create_n_requests(2, "jumpstartlab", requestType: "GET")
    create_n_requests(5, "jumpstartlab", requestType: "POST")
    create_n_requests(1, "jumpstartlab", requestType: "PUT")
    create_n_requests(10, "jumpstartlab", requestType: "DELETE")

    assert_equal 1, Url.count
    url = Url.first
    assert_equal "http://jumpstartlab.com/blog", url.address
    assert_equal 18, url.payload_requests.count
    assert_equal ["DELETE", "POST", "GET", "PUT"], url.http_verbs
  end

  def test_url_returns_three_most_popular_referrers
    create_n_requests(2, "jumpstartlab", referredBy: "www.hitlist.com")
    create_n_requests(9, "jumpstartlab", referredBy: "http://google.com")
    create_n_requests(3, "jumpstartlab", referredBy: "http://youtube.com")
    create_n_requests(7, "jumpstartlab", referredBy: "http://netflix.com")

    assert_equal 1, Url.count
    url = Url.first

    assert_equal 21, PayloadRequest.count
    assert_equal 1, Client.count
    assert_equal ["http://google.com", "http://netflix.com", "http://youtube.com"], url.most_popular_referrers
  end

  def test_url_returns_three_most_popular_user_agents
    create_n_requests(2, "jumpstartlab", userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
    create_n_requests(9, "jumpstartlab", userAgent: "Mozilla/5.0 (X11; Linux i586; rv:31.0) Gecko/20100101 Firefox/31.0")
    create_n_requests(3, "jumpstartlab", userAgent: "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)")
    create_n_requests(7, "jumpstartlab", userAgent: "Mozilla/5.0 (PLAYSTATION 3; 1.10)")
    
    assert_equal 1, Url.count
    url = Url.first

    assert_equal ["Linux Firefox", "Other NetFront", "Windows 7 IE"], url.most_popular_useragents
  end


end
