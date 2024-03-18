require "test_helper"

class SharedFileTest < ActiveSupport::TestCase
  test "can create valid shared file" do
    attached_file = File.open("test/fixtures/files/meme.png")
    expires_at = Time.now + 10.minutes
    file = SharedFile.new(attached_file: attached_file, expires_at: expires_at)
    assert file.valid?
  end

  test "shared file invalid without expires_at" do
    attached_file = File.open("test/fixtures/files/meme.png")
    file = SharedFile.new(attached_file: attached_file)
    refute file.valid?
  end
  
  test "shared file invalid without attached_file" do
    expires_at = Time.now + 10.minutes
    file = SharedFile.new(expires_at: expires_at)
    refute file.valid?
  end
end
