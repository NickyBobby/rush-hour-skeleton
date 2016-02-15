require_relative '../test_helper'

class UserCanSeeUrlStatsTest < FeatureTest

  def test_user_can_see_max_response_time_for_url
    Client.create(identifier: "nickrinna", root_url: "http://nickrinna.com")
    create_n_requests(1, "nickrinna", {url: "http://nickrinna.com/emojis", respondedIn: 80} )
    create_n_requests(1, "nickrinna", {url: "http://nickrinna.com/emojis"})
    create_n_requests(1, "nickrinna", {url: "http://nickrinna.com/blog", respondedIn: 25})

    visit '/sources/nickrinna/urls/emojis'

    within("#url_stats") do
      assert page.has_content?("Max response time (ms): 80")
      assert page.has_content?("Min response time (ms): 37")
      assert page.has_content?("Average response time (ms): 58.5")
      assert page.has_content?("All response times (ms): 80, 37")
    end

  end

  def test_find_the_most_frequent_request_type
    Client.create(identifier: "nickrinna", root_url: "http://nickrinna.com")
    create_n_requests(4, "nickrinna", {url: "http://nickrinna.com/emojis", requestType: "POST"} )
    create_n_requests(1, "nickrinna", {url: "http://nickrinna.com/emojis", requestType: "PUT"} )
    create_n_requests(2, "nickrinna", {url: "http://nickrinna.com/emojis", requestType: "GET"} )

    visit '/sources/nickrinna/urls/emojis'
    #
    within ("#url_stats") do
      assert page.has_content?("All HTTP verbs used: POST, GET, PUT")
    end
  end

  def test_find_the_top_three_most_popular_referrers
    Client.create(identifier: "nickrinna", root_url: "http://nickrinna.com")
    create_n_requests(8, "nickrinna", {url: "http://nickrinna.com/emojis", referredBy: "http://nickybobby.com/giphycentral/links"} )
    create_n_requests(1, "nickrinna", {url: "http://nickrinna.com/emojis", referredBy: "http://google.com"} )
    create_n_requests(5, "nickrinna", {url: "http://nickrinna.com/emojis", referredBy: "http://nickrinna.com/blog"} )

    visit '/sources/nickrinna/urls/emojis'

    within ("#url_stats") do
      assert page.has_content?("Top three most popular referrers: http://nickybobby.com/giphycentral/links, http://nickrinna.com/blog, http://google.com")
    end
  end

  def test_find_the_top_three_most_popular_user_agents
    Client.create(identifier: "nickrinna", root_url: "http://nickrinna.com")

    create_n_requests(8, "nickrinna", {url: "http://nickrinna.com/emojis", userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"})
    create_n_requests(6, "nickrinna", {url: "http://nickrinna.com/emojis", userAgent: "Mozilla/5.0 (X11; Linux i586; rv:31.0) Gecko/20100101 Firefox/31.0"})
    create_n_requests(5, "nickrinna", {url: "http://nickrinna.com/emojis", userAgent: "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)"})
    create_n_requests(3, "nickrinna", {url: "http://nickrinna.com/emojis", userAgent: "Mozilla/5.0 (PLAYSTATION 3; 1.10)"})

    visit '/sources/nickrinna/urls/emojis'
    
    within ("#url_stats") do
      assert page.has_content?("Top three most popular user agents: Mac OS X 10.8.2 Chrome, Linux Firefox, Windows 7 IE")
    end
  end

end
