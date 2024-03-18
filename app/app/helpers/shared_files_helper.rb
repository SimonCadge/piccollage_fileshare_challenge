module SharedFilesHelper
    def is_active(shared_file)
        shared_file.expires_at >= Time.now
    end
end
