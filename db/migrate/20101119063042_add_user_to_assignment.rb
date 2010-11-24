class AddUserToAssignment < ActiveRecord::Migration
  def self.up
    add_column :assignments, :user_id, :integer
  end

  def self.down
    remove_column :assignments, :user_id
  end
end
