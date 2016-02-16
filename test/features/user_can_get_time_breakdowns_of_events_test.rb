require_relative '../test_helper'

class UserGetsTimeBreakdownOfEventsTest < FeatureTest

  def test_user_can_see_time_breakdowns_for_specific_events
    Client.create(identifier: "nickrinna", root_url: "http://nickrinna.com")

    create_n_requests(3, "nickrinna", {url: "http://nickrinna.com/emojis",
      eventName: "clientLogin"})
    create_n_requests(3, "nickrinna", {url: "http://nickrinna.com/giphys",
      eventName: "clientLogin"})
    create_n_requests(4, "nickrinna", {url: "http://nickrinna.com/giphys",
      eventName: "socialLogin"})

    visit '/sources/nickrinna'

    click_link "clientLogin"
    assert_equal '/sources/nickrinna/events/clientLogin', current_path

    within("#event_stats") do
      assert page.has_content?("Event name: clientLogin")
      assert page.has_content?("Total 24 hour breakdown: 6")
      assert page.has_content?("Between 9 and 10 PM: 6")
    end
  end

  def test_user_gets_redirected_when_event_does_not_exist
    Client.create(identifier: "nickrinna", root_url: "http://nickrinna.com")

    create_n_requests(3, "nickrinna", {url: "http://nickrinna.com/emojis",
      eventName: "clientLogin"})
    create_n_requests(3, "nickrinna", {url: "http://nickrinna.com/giphys",
      eventName: "clientLogin"})
    create_n_requests(4, "nickrinna", {url: "http://nickrinna.com/giphys",
      eventName: "socialLogin"})

    visit '/sources/nickrinna/events/adminLogin'


    within("#no_event") do
      assert page.has_content?("adminLogin event does not exist")
    end
    click_link 'here'
    assert_equal '/sources/nickrinna/events', current_path
    
    within("#events") do
      assert page.has_content?("Event breakdown: ")
      assert page.has_content?("socialLogin")
      assert page.has_content?("clientLogin")
    end
  end

end
