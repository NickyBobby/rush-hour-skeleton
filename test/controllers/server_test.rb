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

end
