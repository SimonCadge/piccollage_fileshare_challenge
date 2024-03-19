module SharedFilesHelper
    def belongs_to_current_user(shared_file)
        shared_file.user == current_user
    end
end
