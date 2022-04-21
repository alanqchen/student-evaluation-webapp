class Project < ApplicationRecord
  belongs_to :course

  validates :name, presence: true
  validates :closed, inclusion: { in: [ true, false ] }
end
