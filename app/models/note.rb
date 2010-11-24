class Note < ActiveRecord::Base
  validates_presence_of :description, :priority, :label
  validates_numericality_of :priority

  #has_one :assignments, :as => :assignable, :dependent => :destroy
  has_one :assignments, :as => :assignable

end
