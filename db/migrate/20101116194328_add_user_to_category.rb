class AddUserToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :user, :integer
  end

  def self.down
    remove_column :categories, :user
  end
end
