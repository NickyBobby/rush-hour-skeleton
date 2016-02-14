require_relative '../test_helper'

class UserGetsUrlStatsTest < FeatureTest

  def test_user_gets_redirected_to_url_stats_page
    Client.create(identifier: "nickrinna", root_url: "http://nickrinna.com")

    rp1 = raw_payload
    rp1[:url] = "http://nickrinna.com/emojis"
    rp2 = raw_payload
    rp2[:url] = "http://nickrinna.com/giphys"
    rp3 = raw_payload
    rp3[:url] = "http://nickrinna.com/blog"

    PayloadParser.parse(rp1, "nickrinna")
    PayloadParser.parse(rp2, "nickrinna")
    PayloadParser.parse(rp3, "nickrinna")

    visit '/sources/nickrinna'
    click_link("http://nickrinna.com/giphys")
    save_and_open_page
    assert_equal '/sources/nickrinna/urls/giphys', current_path
    assert page.has_content?("Stats for http://nickrinna.com/giphys:")

  end
end
