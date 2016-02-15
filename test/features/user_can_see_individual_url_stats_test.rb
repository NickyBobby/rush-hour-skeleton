require_relative '../test_helper'

class UserCanSeeUrlStatsTest < FeatureTest

  def test_user_can_see_max_response_time_for_url
    Client.create(identifier: "nickrinna", root_url: "http://nickrinna.com")

    rp1 = raw_payload
    rp1[:url] = "http://nickrinna.com/emojis"
    rp1[:respondedIn] = 80
    rp2 = raw_payload
    rp2[:url] = "http://nickrinna.com/emojis"
    rp3 = raw_payload
    rp3[:url] = "http://nickrinna.com/blog"

    PayloadParser.parse(rp1, "nickrinna")
    PayloadParser.parse(rp2, "nickrinna")
    PayloadParser.parse(rp3, "nickrinna")

    visit '/sources/nickrinna/urls/emojis'
    save_and_open_page
    within("#url_stats") do
      assert page.has_content?("Max response time (ms): 80")
      assert page.has_content?("Min response time (ms): 37")
      assert page.has_content?("Average response time (ms): 58.5")
      assert page.has_content?("All response times (ms): 80, 37")
    end

  end

  def test_find_the_most_frequent_request_type
    Client.create(identifier: "nickrinna", root_url: "http://nickrinna.com")

    rp1 = raw_payload
    rp1[:requestType] = "PUT"
    rp1[:url] = "http://nickrinna.com/emojis"
    rp2 = raw_payload
    rp2[:requestType] = "POST"
    rp2[:url] = "http://nickrinna.com/emojis"
    rp3 = raw_payload
    rp3[:requestType] = "POST"
    rp3[:url] = "http://nickrinna.com/emojis"
    rp4 = raw_payload
    rp4[:url] = "http://nickrinna.com/emojis"
    rp5 = raw_payload
    rp5[:url] = "http://nickrinna.com/emojis"
    rp6 = raw_payload
    rp6[:requestType] = "POST"
    rp6[:url] = "http://nickrinna.com/emojis"

    PayloadParser.parse(rp1, "nickrinna")
    PayloadParser.parse(rp2, "nickrinna")
    PayloadParser.parse(rp3, "nickrinna")
    PayloadParser.parse(rp4, "nickrinna")
    PayloadParser.parse(rp5, "nickrinna")
    PayloadParser.parse(rp6, "nickrinna")

    visit '/sources/nickrinna/urls/emojis'
    #
    within ("#url_stats") do
      assert page.has_content?("All HTTP verbs used: POST, GET, PUT")
    end
  end

  def test_find_the_top_three_most_popular_referrers
    Client.create(identifier: "nickrinna", root_url: "http://nickrinna.com")

    rp1 = raw_payload
    rp1[:referredBy] = "http://google.com"
    rp1[:url] = "http://nickrinna.com/emojis"
    rp2 = raw_payload
    rp2[:referredBy] = "http://nickrinna.com/blog"
    rp2[:url] = "http://nickrinna.com/emojis"
    rp3 = raw_payload
    rp3[:referredBy] = "http://nickrinna.com/blog"
    rp3[:url] = "http://nickrinna.com/emojis"
    rp4 = raw_payload
    rp4[:url] = "http://nickrinna.com/emojis"
    rp4[:referredBy] = "http://nickybobby.com/giphycentral/links"
    rp5 = raw_payload
    rp5[:url] = "http://nickrinna.com/emojis"
    rp5[:referredBy] = "http://nickybobby.com/giphycentral/links"
    rp6 = raw_payload
    rp6[:referredBy] = "http://nickybobby.com/giphycentral/links"
    rp6[:url] = "http://nickrinna.com/emojis"

    PayloadParser.parse(rp1, "nickrinna")
    PayloadParser.parse(rp2, "nickrinna")
    PayloadParser.parse(rp3, "nickrinna")
    PayloadParser.parse(rp4, "nickrinna")
    PayloadParser.parse(rp5, "nickrinna")
    PayloadParser.parse(rp6, "nickrinna")

    visit '/sources/nickrinna/urls/emojis'
    #
    within ("#url_stats") do
      assert page.has_content?("Top three most popular referrers: http://nickybobby.com/giphycentral/links, http://nickrinna.com/blog, http://google.com")
    end
  end

  def test_find_the_top_three_most_popular_user_agents
    Client.create(identifier: "nickrinna", root_url: "http://nickrinna.com")

    rp1 = raw_payload
    rp1[:userAgent] = "Mozilla/5.0 (X11; Linux i586; rv:31.0) Gecko/20100101 Firefox/31.0"
    rp1[:url] = "http://nickrinna.com/emojis"
    rp2 = raw_payload
    rp2[:userAgent] = "Mozilla/5.0 (X11; Linux i586; rv:31.0) Gecko/20100101 Firefox/31.0"
    rp2[:url] = "http://nickrinna.com/emojis"
    rp3 = raw_payload
    rp3[:url] = "http://nickrinna.com/emojis"
    rp4 = raw_payload
    rp4[:url] = "http://nickrinna.com/emojis"
    rp5 = raw_payload
    rp5[:url] = "http://nickrinna.com/emojis"
    rp6 = raw_payload
    rp6[:userAgent] = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)"
    rp6[:url] = "http://nickrinna.com/emojis"

    PayloadParser.parse(rp1, "nickrinna")
    PayloadParser.parse(rp2, "nickrinna")
    PayloadParser.parse(rp3, "nickrinna")
    PayloadParser.parse(rp4, "nickrinna")
    PayloadParser.parse(rp5, "nickrinna")
    PayloadParser.parse(rp6, "nickrinna")

    visit '/sources/nickrinna/urls/emojis'
    #
    within ("#url_stats") do
      assert page.has_content?("Top three most popular user agents: Mac OS X 10.8.2 Chrome, Linux Firefox, Windows 7 IE")
    end
  end

end
