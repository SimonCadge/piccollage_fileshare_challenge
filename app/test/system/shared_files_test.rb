require "application_system_test_case"

class SharedFilesTest < ApplicationSystemTestCase
  setup do
    @shared_file = shared_files(:cv)
  end

  test "visiting the index" do
    visit shared_files_url
    assert_selector "h1", text: "Shared files"
  end

  test "should create shared file" do
    visit shared_files_url
    click_on "New shared file"

    attach_file("shared_file_attached_file", "test/fixtures/files/meme.png")
    click_on "Create Shared file"

    assert_text "Shared file was successfully created"
    click_on "Back"
  end

  test "should destroy Shared file" do
    visit shared_file_url(@shared_file)
    click_on "Destroy this shared file", match: :first

    assert_text "Shared file was successfully destroyed"
  end
end
