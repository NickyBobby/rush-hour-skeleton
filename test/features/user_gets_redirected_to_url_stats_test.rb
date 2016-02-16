require_relative '../test_helper'

class UserGetsUrlStatsTest < FeatureTest

  def test_user_gets_redirected_to_url_stats_page
    Client.create(identifier: "nickrinna", root_url: "http://nickrinna.com")
    load_payload_requests("nickrinna", url: ["http://nickrinna.com/emojis",
                                        "http://nickrinna.com/giphys",
                                        "http://nickrinna.com/blog"])


    visit '/sources/nickrinna'
    click_link("http://nickrinna.com/giphys")

    assert_equal '/sources/nickrinna/urls/giphys', current_path
    assert page.has_content?("Statistics for http://nickrinna.com/giphys")

  end
end
