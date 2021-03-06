# Controller for Twitter authentication
class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    omni = request.env["omniauth.auth"]
    user = AdminUser.where(:uid => omni["uid"],
                           :token => omni["credentials"].token,
                           :token_secret => omni["credentials"].secret).first

    if user
      flash[:notice] = "Logged in Successfully"
      sign_in_and_redirect user
    else
      redirect_to new_user_registration_path
    end
  end
end
