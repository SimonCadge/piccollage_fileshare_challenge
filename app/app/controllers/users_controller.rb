class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    if not helpers.is_logged_in
      @user = User.new
    else
      redirect_to welcome_index_url, notice: "You're already logged in"
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    helpers.current_user.destroy!
    session[:user_id] = nil

    respond_to do |format|
      format.html { redirect_to session_path, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
