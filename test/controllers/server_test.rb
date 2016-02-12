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
    assert_equal "SO MUCH FAIL", last_response.body
  end


end
