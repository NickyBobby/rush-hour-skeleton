require_relative "../test_helper"
require 'pry'

class PayloadRequestTest < Minitest::Test
  include TestHelpers

  def test_all_attributes_exist
    pr = PayloadRequest.new
    assert_respond_to pr, :url
    assert_respond_to pr, :requested_at
    assert_respond_to pr, :responded_in
    assert_respond_to pr, :referrer
    assert_respond_to pr, :request
    assert_respond_to pr, :event
    assert_respond_to pr, :user_agent
    assert_respond_to pr, :resolution
    assert_respond_to pr, :ip
    assert_respond_to pr, :url_id
    assert_respond_to pr, :referrer_id
    assert_respond_to pr, :request_id
    assert_respond_to pr, :event_id
    assert_respond_to pr, :user_agent_id
    assert_respond_to pr, :resolution_id
    assert_respond_to pr, :ip_id
  end

  def test_can_add_a_payload_request_to_database
    pr0 = PayloadRequest.new(PayloadParser.parse(raw_payload))
    assert pr0.save

    pr = PayloadRequest.all.first
    assert_equal 1, PayloadRequest.all.count
    assert_equal 'http://jumpstartlab.com/blog', pr.url.address
    assert_equal "2013-02-16 21:38:28 -0700", pr.requested_at
    assert_equal 37, pr.responded_in
    assert_equal 'http://jumpstartlab.com', pr.referrer.address
    assert_equal "GET", pr.request.verb
    assert_equal "socialLogin", pr.event.name
    assert_equal "Chrome", pr.user_agent.browser
    assert_equal "Mac OS X 10.8.2", pr.user_agent.platform
    assert_equal "1920", pr.resolution.width
    assert_equal "1280", pr.resolution.height
    assert_equal "63.29.38.211", pr.ip.address
    assert_equal 1, pr.url_id
    assert_equal 1, pr.referrer_id
    assert_equal 1, pr.request_id
    assert_equal 1, pr.event_id
    assert_equal 1, pr.user_agent_id
    assert_equal 1, pr.resolution_id
    assert_equal 1, pr.ip_id
  end

  def test_will_not_create_payload_request_without_all_params
    example_payload.keys.each do |key|
      payload = example_payload
      payload.delete(key)
      PayloadRequest.create(payload)
      assert_equal 0, PayloadRequest.all.count
    end
  end

  def test_will_not_create_payload_request_when_request_details_are_empty
    example_payload.each do |key,value|
      if value.class == String
        payload = example_payload
        payload[key] = ""
        PayloadRequest.create(payload)
        assert_equal 0, PayloadRequest.all.count
      end
    end
  end

  def example_payload
    ({
      url: Url.find_or_create_by(address: 'http://jumpstartlab.com/blog'),
      requested_at: "2013-02-16 21:38:28 -0700",
      responded_in: 37,
      referrer: Referrer.find_or_create_by(address: 'http://jumpstartlab.com'),
      request: Request.find_or_create_by(verb: "GET"),
      event: Event.find_or_create_by(name: 'socialLogin'),
      user_agent: UserAgent.find_or_create_by(browser: "Chrome", platform: "Macintosh"),
      resolution: Resolution.find_or_create_by(width: "1920", height: "1280"),
      ip: Ip.find_or_create_by(address: "63.29.38.211")
    })
  end

end


class CalculationsOnPayloadRequestTest< Minitest::Test
  include TestHelpers

  def test_average_response_time_all_requests
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:respondedIn] = 40
    rp3 = raw_payload
    rp3[:respondedIn] = 20

    PayloadRequest.create(PayloadParser.parse(rp1))
    PayloadRequest.create(PayloadParser.parse(rp2))
    PayloadRequest.create(PayloadParser.parse(rp3))

    assert_equal 32.33, PayloadRequest.average_response_time
  end
  #
  #
  #
  # def test_resolutions_across_all_requests
  #   rp1 = raw_payload
  #   rp2 = raw_payload
  #   rp2[:resolutionWidth] = "2520"
  #   rp2[:resolutionHeight] = "1460"
  #   rp3 = raw_payload
  #   rp3[:resolutionWidth] = "1920"
  #   rp3[:resolutionHeight] = "1460"
  #   rp4 = raw_payload
  #   rp4[:url] = "http://www.google.com"
  #   PayloadRequest.create(PayloadParser.parse(rp1))
  #   PayloadRequest.create(PayloadParser.parse(rp2))
  #   PayloadRequest.create(PayloadParser.parse(rp3))
  #   PayloadRequest.create(PayloadParser.parse(rp4))
  #
  #   Resolution.create(height: "1010", width: "4000")
  #   Resolution.create(height: "3333", width: "5000")
  #
  #   assert_equal 4, PayloadRequest.all.length
  #   assert_equal [], PayloadRequest.resolutions
  #
  # end
  #
  def test_events_listed_received_listed_from_most_to_least
    rp1 = raw_payload
    5.times do
      PayloadRequest.create(PayloadParser.parse(rp1))
    end

    rp2 = raw_payload
    rp2[:eventName]="grumpyCats"
    3.times do
      PayloadRequest.create(PayloadParser.parse(rp2))
    end
    #require 'pry'; binding.pry
    assert_equal 8, PayloadRequest.all.count

    assert_equal ["socialLogin", "grumpyCats"], PayloadRequest.ranked_events
  end

  def test_returns_list_of_all_screen_resolutions_across_all_requests
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:resolutionWidth] = "2520"
    rp2[:resolutionHeight] = "1460"
    rp3 = raw_payload
    rp3[:resolutionWidth] = "1920"
    rp3[:resolutionHeight] = "1460"
    rp4 = raw_payload
    rp4[:url] = "http://www.google.com"
    PayloadRequest.create(PayloadParser.parse(rp1))
    PayloadRequest.create(PayloadParser.parse(rp2))
    PayloadRequest.create(PayloadParser.parse(rp3))
    PayloadRequest.create(PayloadParser.parse(rp4))
    Resolution.create(height: "1010", width: "4000")
    Resolution.create(height: "3333", width: "5000")

    assert_equal ["1920 x 1280", "2520 x 1460", "1920 x 1460"], PayloadRequest.requested_resolutions
   end

  def test_returns_list_of_all_user_agents_browsers
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:userAgent] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10; rv:33.0) Gecko/20100101 Firefox/33.0"
    rp3 = raw_payload
    rp3[:userAgent] = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)"
    rp4 = raw_payload
    rp4[:url] = "http://www.google.com"
    PayloadRequest.create(PayloadParser.parse(rp1))
    PayloadRequest.create(PayloadParser.parse(rp2))
    PayloadRequest.create(PayloadParser.parse(rp3))
    PayloadRequest.create(PayloadParser.parse(rp4))

    assert_equal ["Chrome", "Firefox", "IE"], PayloadRequest.user_agent_browsers
  end

  def test_returns_list_of_all_user_agents_os
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:userAgent] = "Mozilla/5.0 (X11; Linux i586; rv:31.0) Gecko/20100101 Firefox/31.0"
    rp3 = raw_payload
    rp3[:userAgent] = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)"
    rp4 = raw_payload
    rp4[:url] = "http://www.google.com"
    PayloadRequest.create(PayloadParser.parse(rp1))
    PayloadRequest.create(PayloadParser.parse(rp2))
    PayloadRequest.create(PayloadParser.parse(rp3))
    PayloadRequest.create(PayloadParser.parse(rp4))

    assert_equal ["Mac OS X 10.8.2", "Linux", "Windows 7"], PayloadRequest.user_agent_os
  end

  def test_max_response_time_across_all_requests
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:respondedIn] = 40
    rp3 = raw_payload
    rp3[:respondedIn] = 20

    PayloadRequest.create(PayloadParser.parse(rp1))
    PayloadRequest.create(PayloadParser.parse(rp2))
    PayloadRequest.create(PayloadParser.parse(rp3))

    assert_equal 40, PayloadRequest.find_max_response_time
  end

  def test_min_response_time_across_all_requests
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:respondedIn] = 40
    rp3 = raw_payload
    rp3[:respondedIn] = 20

    PayloadRequest.create(PayloadParser.parse(rp1))
    PayloadRequest.create(PayloadParser.parse(rp2))
    PayloadRequest.create(PayloadParser.parse(rp3))

    assert_equal 20, PayloadRequest.find_min_response_time
  end

  def test_find_the_most_frequent_request_type
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:requestType] = "hey now"
    rp3 = raw_payload
    rp3[:requestType] = "hey now"
    rp4 = raw_payload
    rp4[:requestType] = "hey now"
    rp5 = raw_payload
    rp5[:requestType] = "hey now"


    PayloadRequest.create(PayloadParser.parse(rp1))
    PayloadRequest.create(PayloadParser.parse(rp2))
    PayloadRequest.create(PayloadParser.parse(rp3))
    PayloadRequest.create(PayloadParser.parse(rp4))
    PayloadRequest.create(PayloadParser.parse(rp5))

    assert_equal "hey now", PayloadRequest.find_most_frequent_request_type
  end

  def test_returns_list_of_all_HTTP_verbs
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:requestType] = "hey now"
    rp3 = raw_payload
    rp3[:requestType] = "hey now"
    rp4 = raw_payload
    rp4[:requestType] = "hey now"
    rp5 = raw_payload
    rp5[:requestType] = "hey now"


    PayloadRequest.create(PayloadParser.parse(rp1))
    PayloadRequest.create(PayloadParser.parse(rp2))
    PayloadRequest.create(PayloadParser.parse(rp3))
    PayloadRequest.create(PayloadParser.parse(rp4))
    PayloadRequest.create(PayloadParser.parse(rp5))

    assert_equal ["GET", "hey now"], PayloadRequest.find_all_http_verbs
  end


end
