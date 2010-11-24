class Category < ActiveRecord::Base
  has_many :assignments
  belongs_to :user
  validates_presence_of :name, :description
end
