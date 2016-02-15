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
    PayloadParser.parse(raw_payload, "jumpstartlab")

    pr = PayloadRequest.first
    assert_equal 1, PayloadRequest.count
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
    assert_equal "jumpstartlab", pr.client.identifier
    assert_equal 1, pr.url_id
    assert_equal 1, pr.referrer_id
    assert_equal 1, pr.request_id
    assert_equal 1, pr.event_id
    assert_equal 1, pr.user_agent_id
    assert_equal 1, pr.resolution_id
    assert_equal 1, pr.ip_id
    assert_equal 1, pr.client_id
  end

  def test_will_not_create_payload_request_without_all_params
    keys = raw_payload.keys
    keys.delete(:parameters)
    keys.each do |key|
      payload = raw_payload
      payload.delete(key)
      PayloadParser.parse(payload, "jumpstartlab")
      assert_equal 0, PayloadRequest.count
    end
  end

  def test_will_not_create_payload_request_when_request_details_are_empty
    raw_payload.each do |key,value|
      if value.class == String
        payload = raw_payload
        payload[key] = ""
        PayloadParser.parse(payload, "jumpstartlab")
        assert_equal 0, PayloadRequest.count
      end
    end
  end

  def test_will_not_create_two_of_the_same_payload_requests
    load_default_request("nickrinna")
    load_default_request("nickrinna")

    assert_equal 1, PayloadRequest.count
  end

end


class CalculationsOnPayloadRequestTest< Minitest::Test
  include TestHelpers

  def test_average_response_time_all_requests
    load_default_request("google")
    data = {respondedIn: [40, 20]}
    load_payload_requests("helloworld", data)

    assert_equal 32.33, PayloadRequest.average_response_time
  end


  def test_events_listed_received_listed_from_most_to_least
    create_n_requests(5, "jumpstartlab", {eventName: "socialLogin"})
    create_n_requests(3, "jumpstartlab", {eventName: "grumpyCats"})

    assert_equal 8, PayloadRequest.count
    assert_equal ["socialLogin", "grumpyCats"], PayloadRequest.ranked_events
  end

  def test_returns_list_of_all_screen_resolutions_across_all_requests
    load_default_request("nickybobby")
    load_payload_requests("googles", resolution: [["2520", "1460"],["1920", "1460"]])

    assert_equal ["1920 x 1280", "2520 x 1460", "1920 x 1460"], PayloadRequest.requested_resolutions
   end

  def test_returns_list_of_all_user_agents_browsers
    load_default_request("jumpstartlab")
    load_default_request("google")
    load_payload_requests("jumpstartlab", userAgent: [
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10; rv:33.0) Gecko/20100101 Firefox/33.0",
      "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)"])

    assert_equal ["Chrome", "Firefox", "IE"], PayloadRequest.user_agent_browsers
  end

  def test_returns_list_of_all_user_agents_os
    load_default_request("jumpstartlab")
    load_default_request("google")
    load_payload_requests("jumpstartlab", userAgent: [
      "Mozilla/5.0 (X11; Linux i586; rv:31.0) Gecko/20100101 Firefox/31.0",
      "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)"])

    assert_equal ["Mac OS X 10.8.2", "Linux", "Windows 7"], PayloadRequest.user_agent_os
  end

  def test_max_response_time_across_all_requests
    load_default_request("colorado")
    load_payload_requests("colorado", respondedIn: [40,20])

    assert_equal 40, PayloadRequest.find_max_response_time
  end

  def test_min_response_time_across_all_requests
    load_default_request("colorado")
    load_payload_requests("colorado", respondedIn: [40,20])

    assert_equal 20, PayloadRequest.find_min_response_time
  end

  def test_find_the_most_frequent_request_type
    load_default_request("hoppin")
    create_n_requests(5, "hoppin", {requestType: "hey now"})

    assert_equal 6, PayloadRequest.count
    assert_equal "hey now", PayloadRequest.find_most_frequent_request_type
  end

  def test_returns_list_of_all_HTTP_verbs
    load_default_request("underwater")
    create_n_requests(5, "underwater", {requestType: "hey now"})

    assert_equal 6, PayloadRequest.count
    assert_equal ["hey now", "GET"], PayloadRequest.find_all_http_verbs
  end


end
