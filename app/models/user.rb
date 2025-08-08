class User < ApplicationRecord
  USER_PERMIT = %i(name email password password_confirmation).freeze
  MAX_NAME_LENGTH = 50
  MAX_EMAIL_LENGTH = 255
  MIN_PASSWORD_LENGTH = 6
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password
  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true,
                   length: {maximum: MAX_NAME_LENGTH}
  validates :email, presence: true,
                    length: {maximum: MAX_EMAIL_LENGTH},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
                      length: {minimum: MIN_PASSWORD_LENGTH},
                      allow_nil: true

  scope :recent, ->{order(created_at: :desc)}

  attr_accessor :remember_token, :activation_token

  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    update_attribute(:remember_digest, Digest::SHA1.hexdigest(remember_token))
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    Digest::SHA1.hexdigest(token) == digest
  end

  def forget
    update_column(:remember_digest, nil)
  end

  # Activates the account
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = SecureRandom.urlsafe_base64
    self.activation_digest = Digest::SHA1.hexdigest(activation_token)
  end
end
