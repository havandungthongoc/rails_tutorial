class User < ApplicationRecord
  # Constants from settings
  NAME_MAX_LENGTH = SETTINGS[:user][:name_max_length]
  PASSWORD_MIN_LENGTH = SETTINGS[:user][:password_min_length]
  PASSWORD_MAX_LENGTH = SETTINGS[:user][:password_max_length]
  VALID_EMAIL_REGEX = SETTINGS[:user][:valid_email_regex]
  RESERVED_SUBDOMAINS = SETTINGS[:user][:reserved_subdomains]
  BIRTHDAY_RANGE = SETTINGS[:user][:birthday_range]

  # Secure password
  has_secure_password

  # Validations
  validates :name, presence: { message: I18n.t("user.validations.name.presence") },
                   length: { maximum: NAME_MAX_LENGTH, message: I18n.t("user.validations.name.too_long", count: NAME_MAX_LENGTH) }
  validates :email, presence: { message: I18n.t("user.validations.email.presence") },
                    # format: { with: VALID_EMAIL_REGEX, message: I18n.t("user.validations.email.format") },
                    uniqueness: { case_sensitive: false, message: I18n.t("user.validations.email.uniqueness") }
  validates :password, length: { in: PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH, message: I18n.t("user.validations.password.length", min: PASSWORD_MIN_LENGTH, max: PASSWORD_MAX_LENGTH) },
                       allow_nil: true
  validates :subdomain, exclusion: { in: RESERVED_SUBDOMAINS, message: I18n.t("user.validations.subdomain.exclusion", value: "%{value}") },
                        allow_nil: true
  validates :birthday, inclusion: { in: BIRTHDAY_RANGE, message: I18n.t("user.validations.birthday.invalid") },
                      allow_nil: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }

  # Callbacks
  before_save :downcase_email

  private

  def downcase_email
    email&.downcase!
  end
end