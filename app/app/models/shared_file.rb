class SharedFile < ApplicationRecord
    has_one_attached :attached_file
    belongs_to :user
    
    validates :attached_file, presence: true
    validates :expires_at, presence: true
    validates :user, presence: true

    def is_active?
        self.expires_at == Float::INFINITY or self.expires_at >= Time.now
    end
    def belongs_to?(user)
        self.user == user
    end
end
