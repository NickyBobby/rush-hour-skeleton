require_relative '../test_helper'

class UserCanViewStatsTest < FeatureTest

  def test_client_can_view_statistics
    Client.create(identifier: "nickybobby", root_url: "http://nickybobby.com")
    rp1 = raw_payload
    PayloadParser.parse(rp1, "nickybobby")
    visit '/sources/nickybobby'

    assert page.has_content?("nickybobby")
    within ("#stats") do
      assert page.has_content?("Average response time: ")
      assert page.has_content?("Max response time: ")
      assert page.has_content?("Min response time: ")
      assert page.has_content?("Most frequent request type: ")
      assert page.has_content?("All HTTP verbs used: ")
      assert page.has_content?("Requested URLs: ")
      assert page.has_content?("Web browser breakdown: ")
      assert page.has_content?("OS breakdown: ")
      assert page.has_content?("Screen resolutions: ")
    end
  end

  def test_client_can_view_average_response_time
    Client.create(identifier: "nickybobby", root_url: "http://nickybobby.com")
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:respondedIn] = 40
    rp3 = raw_payload
    rp3[:respondedIn] = 20

    PayloadParser.parse(rp1, "nickybobby")
    PayloadParser.parse(rp2, "nickybobby")
    PayloadParser.parse(rp3, "nickybobby")

    visit '/sources/nickybobby'
    within ("#stats") do
      assert page.has_content?("Average response time: 32.33 ms")
    end
  end

  def test_client_can_view_max_response_time
    Client.create(identifier: "nickybobby", root_url: "http://nickybobby.com")
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:respondedIn] = 40
    rp3 = raw_payload
    rp3[:respondedIn] = 20

    PayloadParser.parse(rp1, "nickybobby")
    PayloadParser.parse(rp2, "nickybobby")
    PayloadParser.parse(rp3, "nickybobby")

    visit '/sources/nickybobby'
    within ("#stats") do
      assert page.has_content?("Max response time: 40 ms")
    end
  end

  def test_client_can_view_min_response_time
    Client.create(identifier: "nickybobby", root_url: "http://nickybobby.com")
    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:respondedIn] = 40
    rp3 = raw_payload
    rp3[:respondedIn] = 20

    PayloadParser.parse(rp1, "nickybobby")
    PayloadParser.parse(rp2, "nickybobby")
    PayloadParser.parse(rp3, "nickybobby")

    visit '/sources/nickybobby'
    within ("#stats") do
      assert page.has_content?("Min response time: 20 ms")
    end
  end

  def test_find_the_most_frequent_request_type
    Client.create(identifier: "nickybobby", root_url: "http://nickybobby.com")

    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:requestType] = "POST"
    rp3 = raw_payload
    rp3[:requestType] = "POST"
    rp4 = raw_payload
    rp4[:requestType] = "POST"


    PayloadParser.parse(rp1, "nickybobby")
    PayloadParser.parse(rp2, "nickybobby")
    PayloadParser.parse(rp3, "nickybobby")
    PayloadParser.parse(rp4, "nickybobby")

    visit '/sources/nickybobby'

    within ("#stats") do
      assert page.has_content?("Most frequent request type: POST")
    end
  end

  def test_find_the_most_frequent_request_type
    Client.create(identifier: "nickybobby", root_url: "http://nickybobby.com")

    rp1 = raw_payload
    rp1[:requestType] = "PUT"
    rp2 = raw_payload
    rp2[:requestType] = "POST"
    rp3 = raw_payload
    rp3[:requestType] = "POST"
    rp4 = raw_payload
    rp5 = raw_payload
    rp6 = raw_payload
    rp6[:requestType] = "POST"

    PayloadParser.parse(rp1, "nickybobby")
    PayloadParser.parse(rp2, "nickybobby")
    PayloadParser.parse(rp3, "nickybobby")
    PayloadParser.parse(rp4, "nickybobby")
    PayloadParser.parse(rp5, "nickybobby")
    PayloadParser.parse(rp6, "nickybobby")

    visit '/sources/nickybobby'
    save_and_open_page
    within ("#stats") do
      assert page.has_content?("All HTTP verbs used: POST, GET, PUT")
    end
  end

  def test_returns_list_of_all_requested_urls
    Client.create(identifier: "nickybobby", root_url: "http://nickybobby.com")
    #Client.create(identifier: "google", root_url: "http://google.com")

    rp1 = raw_payload
    rp1[:url] = "http://www.nickybobby.com"
    rp2 = raw_payload
    rp2[:url] = "http://www.nickybobby.com"
    rp3 = raw_payload
    rp3[:url] = "http://www.nickybobby.com"

    rp4 = raw_payload
    rp4[:url] = "http://www.google.com"
    # binding.pry
    PayloadParser.parse(rp1, "nickybobby")
    PayloadParser.parse(rp2, "nickybobby")
    PayloadParser.parse(rp3, "nickybobby")
    PayloadParser.parse(rp4, "nickybobby")

    # assert_equal 2, PayloadRequest.count
    visit '/sources/nickybobby'
    within ("#urls") do
      assert page.has_content?("http://www.nickybobby.com")
      assert page.has_content?("http://www.google.com")
    end
  end

  def test_returns_list_of_all_browsers
    Client.create(identifier: "nickybobby", root_url: "http://nickybobby.com")

    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:userAgent] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10; rv:33.0) Gecko/20100101 Firefox/33.0"
    rp3 = raw_payload
    rp3[:userAgent] = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)"
    rp4 = raw_payload

    PayloadParser.parse(rp1, "nickybobby")
    PayloadParser.parse(rp2, "nickybobby")
    PayloadParser.parse(rp3, "nickybobby")
    PayloadParser.parse(rp4, "nickybobby")

    visit '/sources/nickybobby'
    #
    within ("#stats") do
      assert page.has_content?("Web browser breakdown: Chrome, Firefox, IE")
    end
  end

  def test_returns_list_of_all_user_agents_os
    Client.create(identifier: "nickybobby", root_url: "http://nickybobby.com")

    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:userAgent] = "Mozilla/5.0 (X11; Linux i586; rv:31.0) Gecko/20100101 Firefox/31.0"
    rp3 = raw_payload
    rp3[:userAgent] = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)"
    rp4 = raw_payload

    PayloadParser.parse(rp1, "nickybobby")
    PayloadParser.parse(rp2, "nickybobby")
    PayloadParser.parse(rp3, "nickybobby")
    PayloadParser.parse(rp4, "nickybobby")

    visit '/sources/nickybobby'

    within ("#stats") do
      assert page.has_content?("OS breakdown: Mac OS X 10.8.2, Linux, Windows 7")
    end
  end

  def test_returns_list_of_all_screen_resolutions_across_all_requests
    Client.create(identifier: "nickybobby", root_url: "http://nickybobby.com")

    rp1 = raw_payload
    rp2 = raw_payload
    rp2[:resolutionWidth] = "2520"
    rp2[:resolutionHeight] = "1460"
    rp3 = raw_payload
    rp3[:resolutionWidth] = "1920"
    rp3[:resolutionHeight] = "1460"
    rp4 = raw_payload

    PayloadParser.parse(rp1, "nickybobby")
    PayloadParser.parse(rp2, "nickybobby")
    PayloadParser.parse(rp3, "nickybobby")
    PayloadParser.parse(rp4, "nickybobby")

    visit '/sources/nickybobby'

    within ("#stats") do
      assert page.has_content?("Screen resolutions: 1920 x 1280, 2520 x 1460, 1920 x 1460")
    end
   end










end

# visit '/'
#     click_link("New Skill")
#     fill_in("skill[name]", with: "pizza")
#     fill_in("skill[status]", with: "is juicy")
#     click_button("submit")
#
#     assert_equal "/skills", current_path
#
#     within("#skills") do
#       assert page.has_content?("pizza")
#     end
#

# <h1>Statistics for: <%= @client.identifier %></h1>
# <h3>Average response time: <%= @stats[:average_response_time] %></h3>
# <h3>Max response time: <%= @stats[:max_response_time] %></h3>
# <h3>Min response time: <%= @stats[:min_response_time] %></h3>
# <h3>Most frequent request type: <%= @stats[:most_frequent_request] %></h3>
# <h3>All HTTP verbs used: <%= @stats[:all_http_verbs] %></h3>
# <h3>Requested URLs: <%= @stats[:requested_urls] %></h3>
# <h3>Web browser breakdown: <%= @stats[:browsers] %></h3>
# <h3>OS breakdown: <%= @stats[:os] %></h3>
# <h3>Screen resolutions: <%= @stats[:resolutions] %></h3>

# Average Response time across all requests
# Max Response time across all requests
# Min Response time across all requests
# Most frequent request type
# List of all HTTP verbs used
# List of URLs listed form most requested to least requested
# Web browser breakdown across all requests
# OS breakdown across all requests
# Screen Resolutions across all requests (resolutionWidth x resolutionHeight)
