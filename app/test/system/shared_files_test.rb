require "application_system_test_case"

class SharedFilesTest < ApplicationSystemTestCase
  setup do
    @shared_file = shared_files(:expired_cv)
    log_in_as(users(:david), "david_pass")
  end

  test "should create shared file" do
    visit welcome_index_url
    click_on "New shared file"

    attach_file("shared_file_attached_file", "test/fixtures/files/meme.png")
    click_on "Create Shared file"

    assert_text "Shared file was successfully created"
    click_on "Home"
  end

  test "can revoke link after creating it" do
    visit welcome_index_url
    click_on "New shared file"

    attach_file("shared_file_attached_file", "test/fixtures/files/meme.png")
    click_on "Create Shared file"

    click_on "Manually revoke link"
    
    assert_text "This link has expired and is no longer available to download"
  end

end
