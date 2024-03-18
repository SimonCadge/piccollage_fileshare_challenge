require "test_helper"

class SharedFilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shared_file = shared_files(:cv)
  end

  test "should get index" do
    get shared_files_url
    assert_response :success

    # Assert both fixtures appear on the page
    assert_select 'p', /#{shared_files(:cv).id}/
    assert_select 'p', /#{shared_files(:instructions).id}/
  end

  test "should get new" do
    get new_shared_file_url
    assert_response :success
  end

  test "should create shared_file" do
    assert_difference("SharedFile.count") do
      post shared_files_url, params: { shared_file: { attached_file: fixture_file_upload('meme.png', 'png') } }
    end

    latest_file = SharedFile.order("created_at DESC").first
    
    # Since we're using UUIDs as the id column there is no inherrent ordering of shared files,
    # so to get the last file we sort by most recently created.
    assert_redirected_to shared_file_url(latest_file)

    # Assert that the created file now shows up after following the redirect
    follow_redirect!
    assert_select 'p', /meme.png/

    # Assert that the latest created file has the correct filename
    assert_equal "meme.png", latest_file.attached_file.filename.to_s
    
    # Assert expiration time was calculated correctly
    assert latest_file.expires_at > Time.now + 9.minutes
    assert latest_file.expires_at < Time.now + 11.minutes
  end

  test "should show shared_file" do
    get shared_file_url(@shared_file)
    assert_response :success

    assert_select 'p', /#{@shared_file.id}/
  end

  test "should destroy shared_file" do
    assert_difference("SharedFile.count", -1) do
      delete shared_file_url(@shared_file)
    end

    assert_redirected_to shared_files_url

    # Assert that the deleted file no longer appears in the index
    follow_redirect!
    assert_select 'p', {count: 0, text: /#{@shared_file.id}/}
  end
end
