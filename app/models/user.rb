class User < ApplicationRecord
  USER_PERMIT = %i(name email password password_confirmation).freeze
  MAX_NAME_LENGTH = 50
  MAX_EMAIL_LENGTH = 255
  MIN_PASSWORD_LENGTH = 6
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password
  before_save :downcase_email

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

  attr_accessor :remember_token

  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    update_attribute(:remember_digest, Digest::SHA1.hexdigest(remember_token))
  end

  def authenticated? remember_token
    return false if remember_digest.nil?

    Digest::SHA1.hexdigest(remember_token) == remember_digest
  end

  def forget
    update_column(:remember_digest, nil)
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
