class User < ApplicationRecord
  before_save :downcase_email

  USER_PERMIT = %i[name email password password_confirmation]
  
  MAX_NAME_LENGTH = 50
  MAX_EMAIL_LENGTH = 255
  MIN_PASSWORD_LENGTH = 6
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: { message: :blank }, 
                   length: { maximum: MAX_NAME_LENGTH, message: :too_long }
  validates :email, presence: { message: :blank },
                    length: { maximum: MAX_EMAIL_LENGTH, message: :too_long },
                    format: { with: VALID_EMAIL_REGEX, message: :invalid },
                    uniqueness: { case_sensitive: false, message: :taken }
  validates :password, presence: { message: :blank },
                       length: { minimum: MIN_PASSWORD_LENGTH, message: :too_short },
                       allow_nil: true

  has_secure_password

  private

  def downcase_email
    self.email = email.downcase
  end
end
