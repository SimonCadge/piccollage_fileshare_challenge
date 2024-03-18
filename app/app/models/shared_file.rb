class SharedFile < ApplicationRecord
    validates :expires_at, presence: true
    validates :attached_file, presence: true

    has_one_attached :attached_file

    def is_active
        self.expires_at >= Time.now
    end
end
