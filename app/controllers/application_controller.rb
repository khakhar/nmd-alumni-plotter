class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(user)
    admin_path
  end



  def auth_user_or_guest!
    if !params[:invite_token].blank?
      @invite = StudentInvite.find_by(token: params[:invite_token])
      if !@invite
        render(text: "Oops! That invite token is invalid or has already been used.")
      end
    else
      authenticate_user!
    end
  end
end
