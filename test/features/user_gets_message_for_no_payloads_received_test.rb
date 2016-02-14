require_relative '../test_helper'

class UserGetsNoPayloadMessageTest < FeatureTest

  def test_user_gets_message_for_no_payload_request
    Client.create(identifier: "nickybobby", root_url: "http://nickybobby.com")

    visit '/sources/nickybobby'
    assert page.has_content?("nickybobby")
    assert page.has_content?("No payload requests brah/gal. Go out and hustle.")
  end

end
