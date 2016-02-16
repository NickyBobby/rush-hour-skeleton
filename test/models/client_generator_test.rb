require_relative '../test_helper'

class ClientGeneratorTest < Minitest::Test
  include TestHelpers

  def test_can_store_a_client_not_in_database
    params = {identifier: "nickybobby", rootUrl: "http://www.nickybobby.com"}
    status_code, message = ClientGenerator.register_client(params)

    assert_equal 1, Client.count
    assert_equal "nickybobby", Client.first.identifier
    assert_equal "http://www.nickybobby.com", Client.first.root_url

    assert_equal 200, status_code
    assert_equal "{\"identifier\":\"nickybobby\"}", message
  end

  def test_will_not_store_a_client_already_in_database
    params = {identifier: "nickybobby", rootUrl: "http://www.nickybobby.com"}
    ClientGenerator.register_client(params)
    status_code, message = ClientGenerator.register_client(params)

    assert_equal 1, Client.count
    assert_equal "nickybobby", Client.first.identifier
    assert_equal "http://www.nickybobby.com", Client.first.root_url

    assert_equal 403, status_code
    assert_equal "Identifier already exists brah/gal.", message
  end

  def test_cannot_store_a_client_missing_identifier_or_root_url
    params = {rootUrl: "http://www.nickybobby.com"}
    status_code, message = ClientGenerator.register_client(params)

    assert_equal 0, Client.count
    assert_equal 400, status_code
    assert_equal "Error: identifier can't be blank", message

    params = {identifier: "winterwonderland"}
    status_code, message = ClientGenerator.register_client(params)

    assert_equal 0, Client.count
    assert_equal 400, status_code
    assert_equal "Error: root_url can't be blank", message
  end

  def test_will_not_store_a_client_in_database_if_root_url_is_different
    params = {identifier: "nickybobby",rootUrl: "http://www.nickybobby.com"}
    status_code, message = ClientGenerator.register_client(params)

    assert_equal 1, Client.count
    assert_equal 200, status_code
    assert_equal "{\"identifier\":\"nickybobby\"}", message

    params = {identifier: "nickybobby",rootUrl: "http://nickybobby.com"}
    status_code, message = ClientGenerator.register_client(params)

    assert_equal 1, Client.count
    assert_equal 403, status_code
    assert_equal "Identifier already exists brah/gal.", message
    assert_equal "http://www.nickybobby.com", Client.first.root_url
  end


end
