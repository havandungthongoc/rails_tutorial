class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = t("account_activations.success", default: "Account activated!")
      redirect_to root_url
    else
      flash[:danger] = t("account_activations.invalid_link", default: "Invalid activation link")
      redirect_to root_url
    end
  end
end
