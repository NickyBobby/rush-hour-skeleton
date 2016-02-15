require_relative "../test_helper"

class ClientTest < Minitest::Test
  include TestHelpers

  def test_client_instantiates_with_identifier_and_root_url
    client = Client.new(identifier: "chick-fil-ahhhh", root_url: "www.google.com")
    client.save

    assert_equal "chick-fil-ahhhh", client.identifier
    assert_equal "www.google.com", client.root_url
  end

  def test_client_needs_identifier_and_root_url_to_instantiate
    client = Client.create(identifier: "chick-fil-ahhhh")
    refute client.save
    client = Client.create(root_url: "www.google.com")
    refute client.save
    client = Client.create
    refute client.save
    assert_equal 0, Client.count
  end

  def test_client_has_payload_requests
    client = Client.create(identifier: "kazooos", root_url: "www.giphy.com")
    assert_respond_to client, :payload_requests
  end

  def test_client_has_urls
    PayloadParser.parse(raw_payload, "jumpstartlab")
    assert_equal 1, PayloadRequest.count
    assert_equal 1, Client.count

    client = Client.first

    assert_equal "jumpstartlab", client.identifier
    assert_equal "http://www.jumpstartlab.com", client.root_url
    assert_equal [Url.find_by(address: "http://jumpstartlab.com/blog")], client.urls
  end

  def test_client_has_requests
    PayloadParser.parse(raw_payload, "jumpstartlab")
    assert_equal 1, PayloadRequest.count

    rp2 = raw_payload
    rp2[:requestType] ="POST"
    PayloadParser.parse(rp2, "jumpstartlab")

    assert_equal 1, Client.count
    client = Client.first
    assert_equal "jumpstartlab", client.identifier
    assert_equal "http://www.jumpstartlab.com", client.root_url
    assert_equal [Request.find_by(verb:"GET"), Request.find_by(verb:"POST")], client.requests
  end

  def test_client_has_resolutions
    PayloadParser.parse(raw_payload, "jumpstartlab")
    assert_equal 1, PayloadRequest.count

    rp2 = raw_payload
    rp2[:resolutionWidth] = "2450"
    rp2[:resolutionHeight] = "1380"
    PayloadParser.parse(rp2, "jumpstartlab")

    assert_equal 1, Client.count
    client = Client.first
    assert_equal "jumpstartlab", client.identifier
    assert_equal "http://www.jumpstartlab.com", client.root_url
    assert_equal [Resolution.find_by(height: "1280"), Resolution.find_by(width: "2450")], client.resolutions
  end

  def test_client_has_user_agents
    PayloadParser.parse(raw_payload, "jumpstartlab")
    assert_equal 1, PayloadRequest.count

    rp2 = raw_payload
    rp2[:userAgent] = "Mozilla/5.0 (X11; Linux i586; rv:31.0) Gecko/20100101 Firefox/31.0"
    PayloadParser.parse(rp2, "jumpstartlab")

    assert_equal 1, Client.count
    client = Client.first
    assert_equal "jumpstartlab", client.identifier
    assert_equal "http://www.jumpstartlab.com", client.root_url
    assert_equal [UserAgent.find_by(browser: "Chrome"), UserAgent.find_by(browser: "Firefox")], client.user_agents
  end
end
