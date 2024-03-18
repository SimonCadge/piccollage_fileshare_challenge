require "test_helper"

class SessionControllerTest < ActionDispatch::IntegrationTest
  test "should get login page when not logged in" do
    get session_path
    assert_response :success
    assert_select 'h1', /Please Log in/
  end
  
  test "should redirect to homepage if already logged in" do
    log_in_as(users(:david), "david_pass")

    get session_path
    assert_redirected_to welcome_index_url
  end

  test "should login when posting to session if not logged in" do
    @user = users(:david)
    post session_path, params: { email: @user.email, password: "david_pass", password_confirmation: "david_pass"}
    assert_redirected_to user_url(@user)
    assert_equal @user.id, session[:user_id]
  end
  
  test "should redirect to homepage when posting to session if already logged in" do
    @user = users(:david)
    log_in_as(@user, "david_pass")

    post session_path, params: { email: @user.email, password: "david_pass", password_confirmation: "david_pass"}
    assert_redirected_to welcome_index_url
  end

  test "should log out when deleting session" do
    log_in_as(users(:david), "david_pass")

    delete session_path
    assert_redirected_to session_path
    assert_nil session[:user_id]
  end
end
