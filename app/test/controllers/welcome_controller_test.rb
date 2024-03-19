require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index when logged in" do
    log_in_as(users(:david), "david_pass")

    get welcome_index_url
    assert_response :success
    assert_select "a:match('href', ?)", new_shared_file_path
  end

  test "should redirect to login when logged out" do
    get welcome_index_url
    assert_redirected_to session_path
  end
end
