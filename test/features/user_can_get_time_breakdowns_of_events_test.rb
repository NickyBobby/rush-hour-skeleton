require_relative '../test_helper'

class UserGetsTimeBreakdownOfEventsTest < FeatureTest

  def test_user_can_see_time_breakdowns_for_specific_events
    Client.create(identifier: "nickrinna", root_url: "http://nickrinna.com")

    rp1 = raw_payload
    rp1[:url] = "http://nickrinna.com/emojis"
    rp1[:eventName] = "clientLogin"
    rp2 = raw_payload
    rp2[:url] = "http://nickrinna.com/emojis"
    rp2[:eventName] = "clientLogin"
    rp3 = raw_payload
    rp3[:url] = "http://nickrinna.com/emojis"
    rp3[:eventName] = "clientLogin"


    PayloadParser.parse(rp1, "nickrinna")
    PayloadParser.parse(rp2, "nickrinna")
    PayloadParser.parse(rp3, "nickrinna")

    visit '/sources/nickrinna'
    save_and_open_page

    visit '/sources/nickrinna/events/clientLogin'
    save_and_open_page
    within("#event_stats") do
      assert page.has_content?("Event names: ")
      assert page.has_content?("Times of the day: ")
    end
  end

end
