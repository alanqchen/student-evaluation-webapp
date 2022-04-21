class User < ApplicationRecord
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :teams
  has_many :evaluations

  attr_accessor :remember_token, :activation_token, :temp_password, :reset_token

  before_save { self.email = email.downcase }
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, length: {maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :admin, inclusion: { in: [ true, false ] }
  validates :instructor, inclusion: { in: [ true, false ] }
  validates :student, inclusion: { in: [ true, false ] }
  validates :approver, inclusion: { in: [ true, false ] }

  def extra_password_validation
    unless password.nil?
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
  end
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }
  validate :extra_password_validation
  validates :password_confirmation, presence: true

  # Returns the hash digest of the given string
  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  # Returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persisten sessions
  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  # Forgets a user
  def forget
    update_attribute :remember_digest, nil
  end

  # Returns true if the given token matches the digest
  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  # Activates an account
  def activate
    update_attribute :activated, true
    update_attribute :activated_at, Time.zone.now
  end

  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute :reset_digest, User.digest(reset_token)
    update_attribute :reset_sent_at, Time.zone.now
  end

  # Sends password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

    # Creates and assigns the activation token and digest
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest activation_token
    end
end
