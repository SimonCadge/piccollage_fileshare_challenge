class DefineRelationshipBetweenSharedFileAndUser < ActiveRecord::Migration[7.1]
  def change
    add_belongs_to :shared_files, :user, foreign_key: true, null: false, type: :uuid
  end
end
