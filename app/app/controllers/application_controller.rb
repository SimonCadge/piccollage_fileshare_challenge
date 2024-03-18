class ApplicationController < ActionController::Base
  before_action :require_login

  def require_login
    redirect_to session_path unless session.include? :user_id
  end
end
