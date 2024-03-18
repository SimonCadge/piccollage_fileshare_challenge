json.extract! shared_file, :id, :expires_at, :created_at, :updated_at
if shared_file.is_active
    json.download_link rails_blob_url(shared_file.attached_file)
end
json.url shared_file_url(shared_file, format: :json)
