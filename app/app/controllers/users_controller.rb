class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  # GET /users/1
  def show
    @uploaded_files = SharedFile.where(user: helpers.current_user).order("created_at DESC").all
  end

  # GET /users/new
  def new
    if not helpers.is_logged_in
      @user = User.new
    else
      redirect_to welcome_index_url, notice: "You're already logged in"
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to user_url(@user), notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
