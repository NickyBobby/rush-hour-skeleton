require_relative '../test_helper'

class ServerTest < Minitest::Test
  include TestHelpers

  def test_can_create_payload_request
    post '/sources', {identifier: 'jumpstartlab', root_url: 'http://jumpstartlab.com' }
    assert_equal 1, Client.count
    assert_equal 200, last_response.status
    assert_equal "YASSSSSSS call me doctor.", last_response.body 
  end


end
