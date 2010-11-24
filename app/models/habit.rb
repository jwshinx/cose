class Habit < ActiveRecord::Base
  validates_presence_of :description, :time, :label, :frequency
  has_one :assignments, :as => :assignable
end
