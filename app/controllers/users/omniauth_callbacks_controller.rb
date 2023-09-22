# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController


  before_action :social_login_create, only: %i[facebook google_oauth2 line]

  def facebook
  end

  def google_oauth2
  end
  
  def line
  end

  def failure
    redirect_to root_path
  end
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  private
    def social_login_create
      check_param = params[:partner_code].present? ? params[:partner_code] : cookies[:partner_code]
      @user = User.from_omniauth(request.env["omniauth.auth"],check_param)
      if @user.present?
        sign_in_and_redirect @user, event: :authentication 
        cookies.delete :partner_code
        set_flash_message(:notice, :success, kind: @user.provider) if is_navigational_format?
      else
        redirect_to new_user_registration_url
      end
    end
end
