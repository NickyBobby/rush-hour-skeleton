require_relative "../test_helper"

class ClientTest < Minitest::Test
  include TestHelpers


  def test_client_instantiates_with_identifier_and_root_url
    client = Client.new(identifier: "chick-fil-ahhhh", root_url: "www.google.com")
    assert client.valid?
    client.save

    assert_equal "chick-fil-ahhhh", client.identifier
    assert_equal "www.google.com", client.root_url
  end

  def test_client_needs_identifier_and_root_url_to_instantiate
    client = Client.create(identifier: "chick-fil-ahhhh")
    refute client.valid?
    client = Client.create(root_url: "www.google.com")
    refute client.valid?
    client = Client.create
    refute client.valid?
  end


  def test_client_has_payload_requests
    client = Client.create(identifier: "kazooos", root_url: "www.giphy.com")
    assert_respond_to client, :payload_requests
  end

  def test_client_has_urls
    PayloadRequest.create(PayloadParser.parse(raw_payload))
    assert_equal 1, Client.count
    client = Client.first
    assert_equal "jumpstartlab", client.identifier
    assert_equal "http://jumpstartlab.com", client.root_url
    assert_equal [Url.find_by(address: "http://jumpstartlab.com/blog")], client.urls
  end
end
