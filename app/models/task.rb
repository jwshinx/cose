class Task < ActiveRecord::Base
  validates_presence_of :priority, :label, :due
  validates_numericality_of :priority

  has_one :assignment, :as => :assignable
  
end
