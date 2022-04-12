class User < ApplicationRecord
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :teams
  has_many :evaluations
end
