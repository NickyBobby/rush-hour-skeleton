require_relative '../test_helper'

class UserGetsErrorWhenNoClientTest < FeatureTest

  def test_user_gets_an_error_page_when_no_client_exists
    assert_equal 0, Client.count
    visit '/sources/nickybobby'

    assert page.has_content?("nickybobby does NOT exist!!")
  end
end
