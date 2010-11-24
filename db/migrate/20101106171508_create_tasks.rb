class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.date :due
      t.integer :priority
      t.string :label

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
