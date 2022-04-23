class Project < ApplicationRecord
  belongs_to :course
  has_many :evaluations, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :closed, inclusion: { in: [ true, false ] }
end
