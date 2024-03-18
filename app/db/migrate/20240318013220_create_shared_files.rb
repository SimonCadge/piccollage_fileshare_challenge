class CreateSharedFiles < ActiveRecord::Migration[7.1]
  def change
    create_table :shared_files, id: :uuid do |t|
      t.timestamp :expires_at

      t.timestamps

      t.index :expires_at
    end
  end
end
