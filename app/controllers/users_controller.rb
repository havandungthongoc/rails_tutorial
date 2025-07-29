class UsersController < ApplicationController
  before_action :set_user, only: %i(show edit update destroy)

  def index
    @users = User.recent
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: t("users.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user&.update(user_params)
      redirect_to @user, notice: t("users.update.success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user&.destroy
      redirect_to users_path, notice: t("users.destroy.success")
    else
      redirect_to users_path, alert: t("users.destroy.failed")
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    return if @user
    redirect_to users_path, alert: t("users.not_found")
  end

  def user_params
    params.require(:user).permit(*User::USER_PERMIT)
  end
end
