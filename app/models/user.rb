class User < ApplicationRecord
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :teams
  has_many :evaluations

  attr_accessor :remember_token

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, length: {maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :admin, inclusion: { in: [ true, false ] }
  validates :instructor, inclusion: { in: [ true, false ] }
  validates :student, inclusion: { in: [ true, false ] }
  validates :approver, inclusion: { in: [ true, false ] }

  def extra_password_validation
    rules = {
      "must contain at least one number"           => /(?=.*\d)/, # At least one number
      "must contain at least one lowercase letter" => /(?=.*[a-z])/, # At least one lowercase letter
      "must contain at least one uppercase letter" => /(?=.*[A-Z])/, # At least one uppercase letter
      "must contain at least one symbol" => /(?=.*[[:^alnum:]])/, # At least one symbol
    }
    rules.each do |message, regex|
      errors.add :password, message unless password.match regex
    end
  end
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }
  validate :extra_password_validation
  validates :password_confirmation, presence: true

  # Returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persisten sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forgets a user
  def forget
    update_attribute :remember_digest, nil
  end

  # Returns true if the given token matches the digest
  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
