require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:david)
  end

  test "should create user" do
    visit session_url
    click_on "Sign Up"

    fill_in "Email", with: "test@gmail.com"
    fill_in "Password", with: "test_pass"
    fill_in "Password confirmation", with: "test_pass"
    click_on "Create User"

    assert_text "User was successfully created"
    click_on "Home"
  end
end
