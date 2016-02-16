require_relative '../test_helper'

class PayloadParserTest < Minitest::Test
  include TestHelpers

  def test_parser_can_create_a_valid_payload_request_input
    load_default_request("jumpstartlab")
    assert_equal 1, PayloadRequest.count
    pr = PayloadRequest.first

    assert_equal "http://jumpstartlab.com/blog", pr.url.address
    assert_equal "2013-02-16 21:38:28 -0700", pr.requested_at
    assert_equal 37, pr.responded_in
    assert_equal "http://jumpstartlab.com", pr.referrer.address
    assert_equal "GET", pr.request.verb
    assert_equal "socialLogin", pr.event.name
    assert_equal "Chrome", pr.user_agent.browser
    assert_equal "Mac OS X 10.8.2", pr.user_agent.platform
    assert_equal "1920", pr.resolution.width
    assert_equal "1280", pr.resolution.height
    assert_equal "63.29.38.211", pr.ip.address
    assert_equal "jumpstartlab", pr.client.identifier
    assert_equal "36a0615e2a2fc42e53e4a21f44cb39e4a641dfc546360b82031423bb064221db", pr.payload_sha
  end

  def test_parser_will_create_new_payload_request_with_minute_detail_changes
    load_default_request("jumpstartlab")
    load_payload_requests("jumpstartlab", {requestedAt: ["2013-02-16 21:38:28 -0600"]})
    load_payload_requests("jumpstartlab", {referredBy: ["http://jumpstartlab.com/"]})

    assert_equal 3, PayloadRequest.count
    pr = PayloadRequest.last

    assert_equal "http://jumpstartlab.com/blog", pr.url.address
    assert_equal "2013-02-16 21:38:28 -0700", pr.requested_at
    assert_equal 37, pr.responded_in
    assert_equal "http://jumpstartlab.com/", pr.referrer.address
    assert_equal "GET", pr.request.verb
    assert_equal "socialLogin", pr.event.name
    assert_equal "Chrome", pr.user_agent.browser
    assert_equal "Mac OS X 10.8.2", pr.user_agent.platform
    assert_equal "1920", pr.resolution.width
    assert_equal "1280", pr.resolution.height
    assert_equal "63.29.38.211", pr.ip.address
    assert_equal "jumpstartlab", pr.client.identifier
    assert_equal "2d50144e616b37d23c1dce54d5a95e2b192822227d9ceef903be40d32abad746", pr.payload_sha
  end

end
