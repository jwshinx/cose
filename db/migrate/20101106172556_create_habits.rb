class CreateHabits < ActiveRecord::Migration
  def self.up
    create_table :habits do |t|
      t.text :description
      t.datetime :time
      t.string :label
      t.string :frequency

      t.timestamps
    end
  end

  def self.down
    drop_table :habits
  end
end
