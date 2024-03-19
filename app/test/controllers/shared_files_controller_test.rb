require "test_helper"

class SharedFilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expired_cv_file = shared_files(:expired_cv)
    @active_instructions_file = shared_files(:active_instructions)
    log_in_as(users(:david), "david_pass")
  end

  test "should get new html page" do
    get new_shared_file_url
    assert_response :success
    assert_select "input:match('id', ?)", "shared_file_attached_file"
  end
  
  test "redirected to login when trying to create new file while logged out" do
    log_out
    get new_shared_file_url
    assert_redirected_to session_path
  end

  test "should create shared_file" do
    assert_difference("SharedFile.count") do
      post shared_files_url, params: { shared_file: { attached_file: fixture_file_upload('meme.png', 'png'), link_type: 'short' } }
    end

    # Since we're using UUIDs as the id column there is no inherrent ordering of shared files,
    # so to get the last file we sort by most recently created.
    latest_file = SharedFile.order("created_at DESC").first
    assert_redirected_to shared_file_url(latest_file)
    # Should have been placed in the short folder
    assert latest_file.attached_file.key.start_with?("short")

    # Assert that the created file now shows up after following the redirect
    follow_redirect!
    assert_select 'p', /meme.png/

    # Assert that the latest created file has the correct filename
    assert_equal "meme.png", latest_file.attached_file.filename.to_s
    
    # Assert expiration time was calculated correctly
    assert latest_file.expires_at > Time.now + 9.minutes
    assert latest_file.expires_at < Time.now + 11.minutes
  end

  test "can create long link" do
    assert_difference("SharedFile.count") do
      post shared_files_url, params: { shared_file: { attached_file: fixture_file_upload('meme.png', 'png'), link_type: 'long' } }
    end

    # Since we're using UUIDs as the id column there is no inherrent ordering of shared files,
    # so to get the last file we sort by most recently created.
    latest_file = SharedFile.order("created_at DESC").first
    assert_redirected_to shared_file_url(latest_file)
    # Should have been placed in the long folder
    assert latest_file.attached_file.key.start_with?("long")

    assert latest_file.expires_at > Time.now + 59.minutes
    assert latest_file.expires_at < Time.now + 61.minutes
  end

  test "can create infinite link" do
    assert_difference("SharedFile.count") do
      post shared_files_url, params: { shared_file: { attached_file: fixture_file_upload('meme.png', 'png'), link_type: 'forever' } }
    end

    # Since we're using UUIDs as the id column there is no inherrent ordering of shared files,
    # so to get the last file we sort by most recently created.
    latest_file = SharedFile.order("created_at DESC").first
    assert_redirected_to shared_file_url(latest_file)
    # Should have been placed in the forever folder
    assert latest_file.attached_file.key.start_with?("forever")

    assert latest_file.expires_at == Float::INFINITY
  end

  test "can't post new file when logged out" do
    log_out

    assert_no_difference("SharedFile.count") do
      post shared_files_url, params: { shared_file: { attached_file: fixture_file_upload('meme.png', 'png') } }
    end

    assert_redirected_to session_path
  end

  test "should show active shared_file" do
    get shared_file_url(@active_instructions_file)
    assert_response :success

    assert_select 'p', /#{@active_instructions_file.id}/
    assert_select "a:match('href', ?)", rails_blob_path(@active_instructions_file.attached_file)
  end

  test "option to revoke active shared_file only visible to creator of the file" do
    get shared_file_url(@active_instructions_file)
    assert_response :success

    # We're current logged in as david, so shouldn't be able to revoke wendy's file
    assert_select 'button', {count: 0, text: /Manually revoke link/}

    log_out
    log_in_as(users(:wendy), "wendy_pass")
    get shared_file_url(@active_instructions_file)
    assert_response :success

    # Now we are logged in as wendy, so the option to revoke the link should appear
    assert_select 'button', /Manually revoke link/
  end

  test "owner of a file can manually revoke the link if it hasn't already expired" do
    assert @active_instructions_file.is_active

    log_out
    log_in_as(users(:wendy), "wendy_pass")
    patch shared_file_url(@active_instructions_file)

    @active_instructions_file.reload
    assert_not @active_instructions_file.is_active
  end
  
  test "even guest users can access shared file via link" do
    log_out

    get shared_file_url(@active_instructions_file)
    assert_response :success
  end
  
  test "show expired shared_file should instead show message saying link has expired" do
    get shared_file_url(@expired_cv_file)
    assert_response :success

    assert_select 'p', "This link has expired and is no longer available to download"
    assert_select 'p', {count: 0, text: /#{@active_instructions_file.id}/}
  end
end
