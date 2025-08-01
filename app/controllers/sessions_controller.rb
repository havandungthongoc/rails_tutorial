class SessionsController < ApplicationController
  before_action :load_user, only: :create
  before_action :check_authentication, only: :create

  # Handles user login and session creation
  def create
    reset_session
    log_in(@user)
    redirect_to user_path(@user), status: :see_other
  end

  def destroy
    log_out
    redirect_to root_path, status: :see_other
  end

  private

  def load_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
    return if @user

    flash.now[:danger] = t("user_not_found")
    render :new, status: :unprocessable_entity
  end

  def check_authentication
    return if @user.authenticate(params.dig(:session, :password))

    flash.now[:danger] = t("invalid_email_password_combination")
    render :new, status: :unprocessable_entity
  end
end
