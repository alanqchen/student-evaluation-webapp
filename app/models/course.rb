class Course < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :teams
  has_many :projects

  validates :name, presence: true
  validates :active, inclusion: { in: [ true, false ] }
end
