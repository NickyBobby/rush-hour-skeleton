require_relative '../test_helper'

class UserCanViewStatsTest < FeatureTest

  def test_client_can_view_statistics
    load_default_request("nickybobby")
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
    load_default_request("nickybobby")
    load_payload_requests("nickybobby", respondedIn: [40,20])

    visit '/sources/nickybobby'

    within ("#stats") do
      assert page.has_content?("Average response time: 32.33 ms")
      assert page.has_content?("Max response time: 40 ms")
      assert page.has_content?("Min response time: 20 ms")
    end
  end

  def test_find_the_most_frequent_request_type
    load_default_request("nickybobby")
    create_n_requests(5, "hoppin", {requestType: "POST"})
    assert_equal 6, PayloadRequest.count

    visit '/sources/nickybobby'

    within ("#stats") do
      assert page.has_content?("Most frequent request type: POST")
    end
  end

  def test_find_the_most_frequent_request_type
    create_n_requests(5, "nickybobby", {requestType: "POST"})
    create_n_requests(1, "nickybobby", {requestType: "PUT"})
    create_n_requests(4, "nickybobby", {requestType: "GET"})

    visit '/sources/nickybobby'

    within ("#stats") do
      assert page.has_content?("All HTTP verbs used: POST, GET, PUT")
    end
  end

  def test_returns_list_of_all_requested_urls
    create_n_requests(1, "nickybobby", url: "http://www.nickybobby.com/giphys/advanced")
    create_n_requests(4, "nickybobby", url: "http://www.nickybobby.com/emojis")

    visit '/sources/nickybobby'

    within ("#urls") do
      assert page.has_content?("http://www.nickybobby.com/emojis")
      assert page.has_content?("http://www.nickybobby.com/giphys/advanced")
    end
  end

  def test_returns_list_of_all_browsers
    load_default_request("nickybobby")
    load_payload_requests("nickybobby", userAgent: [
      "Mozilla/5.0 (X11; Linux i586; rv:31.0) Gecko/20100101 Firefox/31.0",
      "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)"])

    visit '/sources/nickybobby'

    within ("#stats") do
      assert page.has_content?("Web browser breakdown: Chrome, Firefox, IE")
      assert page.has_content?("OS breakdown: Mac OS X 10.8.2, Linux, Windows 7")
    end
  end

  def test_returns_list_of_all_screen_resolutions_across_all_requests
    load_default_request("nickybobby")
    load_payload_requests("nickybobby", resolution: [["2520", "1460"],["1920", "1460"]])

    visit '/sources/nickybobby'

    within ("#stats") do
      assert page.has_content?("Screen resolutions: 1920 x 1280, 2520 x 1460, 1920 x 1460")
    end
   end

end
