class SessionController < ApplicationController
  skip_before_action :require_login, only: [:create, :new]

  def new
    if helpers.is_logged_in
      redirect_to welcome_index_url, notice: "You're already logged in"
    end
  end

  def create
    if not helpers.is_logged_in
      @user = User.find_by(email: session_params[:email])
      if @user && @user.authenticate(session_params[:password])
        session[:user_id] = @user.id
        redirect_to @user
      else
        redirect_to session_path, notice: "Login is Invalid!"
      end
    else
      redirect_to welcome_index_url, notice: "You're already logged in"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to session_path, notice: "You have been signed out!"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # Only allow a list of trusted parameters through.
    def session_params
      params.permit(:email, :password)
    end
end
