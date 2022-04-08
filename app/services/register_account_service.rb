class RegisterAccountService
  prepend SimpleCommand

  def initialize(username, password, password_confirmation)
      @username = username
      @password = password
      @password_confirmation = password_confirmation
  end

  def call
    if valid?
      user = User.create(
        username: username,
        password: password
      )

      if user.errors.present?
        errors.add(:validate, user.errors.full_messages.join("\n"))
      end
    end
  end

  private

  attr_accessor :username, :password, :password_confirmation

  def valid?
    match_password_confirmation? &&
    not_duplicate_username?
  end

  def match_password_confirmation?
    password == password_confirmation ||
      errors.add(:password_confirmation, 'Password confirm is not match')
  end

  def not_duplicate_username?
    !User.exists?(username: username) ||
      errors.add(:username_exists, 'username was exist')
  end
end