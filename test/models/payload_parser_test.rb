require_relative '../test_helper'

class PayloadParserTest < Minitest::Test
  include TestHelpers

  def test_parser_can_create_a_valid_payload_request_input
    pr = PayloadRequest.new(PayloadParser.parse(example_payload))
    assert pr.save
  end

  def example_payload
    ({
      "url":"http://jumpstartlab.com/blog",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":37,
      "referredBy":"http://jumpstartlab.com",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
    })
  end

end