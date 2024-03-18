require "test_helper"

class SharedFilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expired_cv_file = shared_files(:expired_cv)
    @active_instructions_file = shared_files(:active_instructions)
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

  test "should show active shared_file" do
    get shared_file_url(@active_instructions_file)
    assert_response :success

    assert_select 'p', /#{@active_instructions_file.id}/
    assert_select "a:match('href', ?)", rails_blob_path(@active_instructions_file.attached_file)
  end
  
  test "show expired shared_file should instead show message saying link has expired" do
    get shared_file_url(@expired_cv_file)
    assert_response :success

    assert_select 'p', "This link has expired and is no longer available to download"
    assert_select 'p', {count: 0, text: /#{@active_instructions_file.id}/}
  end

  test "should destroy shared_file" do
    assert_difference("SharedFile.count", -1) do
      delete shared_file_url(@expired_cv_file)
    end

    assert_redirected_to welcome_index_url
  end
end
