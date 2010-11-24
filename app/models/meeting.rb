class Meeting < ActiveRecord::Base
  validates_presence_of :description, :time, :label
  has_one :assignments, :as => :assignable

end
