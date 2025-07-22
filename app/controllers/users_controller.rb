class UsersController < ApplicationController
  before_action :load_user, only: [:show]

  def index
    @users = User.recent
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: t("user.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def load_user
    @user = User.find_by(id: params[:id])
    redirect_to users_path, alert: t("user.not_found") unless @user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :subdomain, :birthday)
  end
end