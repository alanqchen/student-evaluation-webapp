class Evaluation < ApplicationRecord
  belongs_to :from_user, class_name: 'User', foreign_key: 'from_user_id'
  belongs_to :to_user, class_name: 'User', foreign_key: 'to_user_id'
  belongs_to :project, class_name: 'Project', foreign_key: 'project_id'

  validates :score, numericality: { only_integer: true }
  validates :comment, presence: true
  validates :completed, inclusion: { in: [ true, false ] }
end
