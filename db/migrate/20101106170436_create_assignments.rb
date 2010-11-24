class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.references :assignable, :polymorphic => true
      t.string :name
      t.date :reminder
      t.integer :category_id
      t.integer :status_id

      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
