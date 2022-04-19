class Request < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, length: {maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :institution, presence: true, length: { minimum: 1 }
  validates :comments, presence: true, length: { maximum: 1000 }

  def edu_email_validation
    rules = {
      "must be an .edu email" => /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.+-]+\.edu$/
    }
    rules.each do |message, regex|
      errors.add :email, message unless email.match regex
    end
  end

  validate :edu_email_validation

end
