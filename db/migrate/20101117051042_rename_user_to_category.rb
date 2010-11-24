class RenameUserToCategory < ActiveRecord::Migration
  def self.up
    rename_column :categories, :user, :user_id
  end

  def self.down
    rename_column :categories, :user_id, :user
  end
end
