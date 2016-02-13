require_relative '../test_helper'

class ServerTest < Minitest::Test
  include TestHelpers

  def test_can_post_a_client
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com' }
    assert_equal 1, Client.count
    assert_equal 200, last_response.status
    assert_equal "{\"identifier\":\"jumpstartlab\"}", last_response.body
  end

  def test_can_not_post_a_client_without_correct_parameters
    post '/sources', {identifier: 'jumpstartlab'}
    assert_equal 0, Client.count
    assert_equal 400, last_response.status
    assert_equal "Error: {:root_url=>[\"can't be blank\"]}", last_response.body

    post '/sources', {rootUrl: 'http://jumpstartlab.com'}
    assert_equal 0, Client.count
    assert_equal 400, last_response.status
    assert_equal "Error: {:identifier=>[\"can't be blank\"]}", last_response.body

    post '/sources'
    assert_equal 0, Client.count
    assert_equal 400, last_response.status
    assert_equal "Error: {:identifier=>[\"can't be blank\"], :root_url=>[\"can't be blank\"]}", last_response.body

    post '/sources', {other: 'this is not valid'}
    assert_equal 0, Client.count
    assert_equal 400, last_response.status
    assert_equal "Error: {:identifier=>[\"can't be blank\"], :root_url=>[\"can't be blank\"]}", last_response.body
  end

  def test_can_not_post_a_repeat_client
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com' }
    assert_equal 1, Client.count
    assert_equal 200, last_response.status
    assert_equal "{\"identifier\":\"jumpstartlab\"}", last_response.body

    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com' }
    assert_equal 1, Client.count
    assert_equal 403, last_response.status
    assert_equal "Identifier already exists brah/gal.", last_response.body

    # post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://notsocool.com' }
    # assert_equal 1, Client.count
    # assert_equal 403, last_response.status
    # assert_equal "{\"identifier\":\"jumpstartlab\"}", last_response.body
  end

  def test_returns_success_when_can_post_valid_payload_request
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com' }
    assert_equal 1, Client.count
    assert_equal 200, last_response.status
    assert_equal "{\"identifier\":\"jumpstartlab\"}", last_response.body

    post '/sources/jumpstartlab/data', "payload={\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\":\"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"
    assert_equal 1, PayloadRequest.count
    assert_equal "jumpstartlab", PayloadRequest.first.client.identifier
    assert_equal 200, last_response.status
    assert_equal "Great success", last_response.body
  end

  def test_returns_application_not_registered_for_client_not_in_database
    post '/sources/jumpstartlab/data', "payload={\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\":\"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"
    assert_equal 0, PayloadRequest.count
    assert_equal 0, Client.count
    assert_equal 403, last_response.status
    assert_equal "jumpstartlab not found. Cool story brah/gal.", last_response.body
  end

  def test_returns_bad_request_if_payload_is_missing
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com' }
    post '/sources/jumpstartlab/data', "payload={}"
    assert_equal 0, PayloadRequest.count
    assert_equal 1, Client.count
    assert_equal 400, last_response.status
    assert_equal "Error: ", last_response.body
  end

  def test_returns_forbidden_status_if_already_received_request
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com' }
    post '/sources/jumpstartlab/data', "payload={\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\":\"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"

    assert_equal 200, last_response.status

    post '/sources/jumpstartlab/data', "payload={\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\":\"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"

    assert_equal 1, PayloadRequest.count
    assert_equal 403, last_response.status
    assert_equal "Error: Payload Request already received", last_response.body
  end

  def test_returns_bad_request_if_payload_is_incomplete
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com' }
    post '/sources/jumpstartlab/data', "payload={\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\":\"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"

    assert_equal 200, last_response.status

    post '/sources/jumpstartlab/data', "payload={\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\":\"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"

    assert_equal 1, PayloadRequest.count
    assert_equal 400, last_response.status
    assert_equal "Error: ", last_response.body
  end

  def test_loads_similar_payload_requests
    post '/sources', {identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com' }
    post '/sources/jumpstartlab/data', "payload={\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\":\"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"

    assert_equal 200, last_response.status

    post '/sources/jumpstartlab/data', "payload={\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":39,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\":\"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"

    assert_equal 2, PayloadRequest.count
    assert_equal 200, last_response.status
    assert_equal "Great success", last_response.body
  end





end
