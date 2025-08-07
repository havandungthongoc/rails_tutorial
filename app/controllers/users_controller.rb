class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :set_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @per_page = 10
    @page = (params[:page] || 1).to_i
    @users = search_users.limit(@per_page).offset((@page - 1) * @per_page)
    @total_pages = (search_users.count.to_f / @per_page).ceil
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t("users.create.activation_email_sent", default: "Please check your email to activate your account.")
      redirect_to root_url
    else
      flash[:danger] = t("users.new.errors_count", count: @user.errors.count, default: "%{count} errors:")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: t("users.update.success")
    else
      flash.now[:alert] = t("users.update.failed")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
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

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("sessions.please_login")
    redirect_to login_url
  end

  def correct_user
    return if @user == current_user

    flash[:error] = t("users.access_denied")
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    flash[:error] = t("users.admin_only")
    redirect_to root_url
  end

  def search_users
    if params[:search].present?
      User.where(
        "name LIKE ? OR email LIKE ?",
        "%#{params[:search]}%",
        "%#{params[:search]}%"
      ).recent
    else
      User.recent
    end
  end
end
