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
  # TODO: Add unique index for email in DB for full safety
  validates :password, presence: true,
                       length: {minimum: MIN_PASSWORD_LENGTH},
                       allow_nil: true

  scope :recent, ->{order(created_at: :desc)}

  private

  def downcase_email
    self.email = email.downcase
  end
end
