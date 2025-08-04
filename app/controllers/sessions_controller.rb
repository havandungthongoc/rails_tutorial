# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  before_action :require_login, only: :destroy
  before_action :load_user, only: :create
  before_action :check_authentication, only: :create
  REMEMBER_ME_CHECKED = "1".freeze

  def new; end

  def create
    log_in(@user)
    if params.dig(:session, :remember_me) == REMEMBER_ME_CHECKED
      remember @user
    else
      forget @user
    end
    redirect_to @user, notice: t("sessions.new.success")
  end

  def destroy
    log_out
    redirect_to root_url, notice: t("sessions.new.logged_out")
  end

  private

  def require_login
    return if logged_in?

    flash[:danger] = t("sessions.new.require_login")
    redirect_to login_url
  end

  def load_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
    return if @user

    flash.now[:danger] = t("sessions.new.invalid_credentials")
    render "new"
  end

  def check_authentication
    return if @user&.authenticate(params.dig(:session, :password))

    flash.now[:danger] = t("sessions.new.invalid_credentials")
    render "new"
  end

  def log_in user
    session[:user_id] = user.id
  end

  def remember user
    user.remember
    cookies.permanent[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user) if logged_in?
    reset_session
    @current_user = nil
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end
end
