require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:david)
  end

  test "new user page shown when not logged in" do
    get new_user_url
    assert_response :success
    assert_select 'h1', /New user/
  end

  test "redirected to homepage when logged in" do
    log_in_as(@user, "david_pass")

    get new_user_url
    assert_redirected_to welcome_index_url
  end

  test "should create user if they are valid" do
    assert_difference("User.count") do
      post users_url, params: { user: { email: "test@gmail.com", password: "test_pass", password_confirmation: "test_pass" } }
    end
    
    assert_redirected_to user_url(User.order("created_at").last)
  end
  
  test "email, password and password confirmation are all required" do  
    # No password
    assert_no_difference("User.count") do
      post users_url, params: { user: { email: "test@gmail.com", password_confirmation: "test_pass" } }
    end
    
    # No email
    assert_no_difference("User.count") do
      post users_url, params: { user: { password: "test_pass", password_confirmation: "test_pass" } }
    end
    
    # Passwords don't match
    assert_no_difference("User.count") do
      post users_url, params: { user: { email: "test@gmail.com", password: "test_pass", password_confirmation: "test_pass2" } }
    end

    # Email already in db
    assert_no_difference("User.count") do
      post users_url, params: { user: { email: "david@gmail.com", password: "test_pass", password_confirmation: "test_pass" } }
    end
  end

  test "should show user when logged in" do
    log_in_as(@user, "david_pass")
    
    get user_url(@user)
    assert_response :success
  end

  test "should destroy user" do
    log_in_as(@user, "david_pass")

    assert_difference("User.count", -1) do
      delete user_url(@user)
    end

    assert_redirected_to session_path
  end
end
