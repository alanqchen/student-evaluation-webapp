class Evaluation < ApplicationRecord
  belongs_to :from_user, class_name: 'User', foreign_key: 'from_user_id'
  belongs_to :to_user, class_name: 'User', foreign_key: 'to_user_id'
  belongs_to :project, class_name: 'Project', foreign_key: 'project_id'
  has_one :course, through: :project, autosave: false

  validates :score, numericality: { only_integer: true }
  validates :comment, presence: true, length: { maximum: 300 }
  validates :completed, inclusion: { in: [ true, false ] }

  def valid_score_range
    errors.add :score, "must be >=0 and <= 5" unless score >= 0 && score <= 5
  end

  validate :valid_score_range
end
