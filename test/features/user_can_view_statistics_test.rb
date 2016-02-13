require_relative '../test_helper'

class UserCanViewStatsTest < FeatureTest

  def test_client_can_view_statistics
    Client.create(identifier: "nickybobby", root_url: "http://nickybobby.com")

    visit '/sources/nickybobby'
    save_and_open_page
    assert page.has_content?("nickybobby")
    within ("#stats") do
      assert page.has_content?("Average response time")
      assert page.has_content?("Max response time")
      assert page.has_content?("Min response time")
      assert page.has_content?("Most frequent request type")
      assert page.has_content?("All HTTP verbs used")
      assert page.has_content?("Requested URLs")
      assert page.has_content?("Web browser breakdown")
      assert page.has_content?("OS breakdown")
      assert page.has_content?("Screen resolutions")
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
#     save_and_open_page

# Average Response time across all requests
# Max Response time across all requests
# Min Response time across all requests
# Most frequent request type
# List of all HTTP verbs used
# List of URLs listed form most requested to least requested
# Web browser breakdown across all requests
# OS breakdown across all requests
# Screen Resolutions across all requests (resolutionWidth x resolutionHeight)
