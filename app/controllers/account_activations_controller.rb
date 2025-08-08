class AccountActivationsController < ApplicationController
  before_action :load_user, only: [:edit]
  before_action :check_authentication, only: [:edit]
  before_action :check_activation, only: [:edit]

  def edit
    user.activate
    log_in user
    flash[:success] = t("account_activations.success")
    redirect_to user
  end

  private

  def load_user
    @user = User.find_by(email: params[:email])
    return if @user

    redirect_to root_url,
                alert: t("account_activations.user_not_found")
  end

  def check_authentication
    return if @user&.authenticated?(:activation, params[:id])

    redirect_to(root_url,
                flash: {danger: t("account_activations.invalid_token")})
  end

  def check_activation
    return unless @user&.activated?

    redirect_to(root_url,
                flash: {warning: t("account_activations.already_activated")})
  end

  def log_in user
    session[:user_id] = user.id
  end
end
