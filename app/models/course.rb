class Course < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :teams, dependent: :destroy
  has_many :projects, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :active, inclusion: { in: [ true, false ] }
end
