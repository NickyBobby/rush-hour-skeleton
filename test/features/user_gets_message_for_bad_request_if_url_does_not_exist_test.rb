require_relative '../test_helper'

class BadRequestIfUrlDoesNotExistTest < FeatureTest

  def test_user_gets_a_message_for_bad_request_if_url_does_not_exist
    Client.create(identifier: "nickrinna", root_url: "http://nickrinna.com")

    visit '/sources/nickrinna/urls/bad-emojis'
    save_and_open_page
    assert page.has_content?("bad-emojis has not been requested, try again.")
  end
end
