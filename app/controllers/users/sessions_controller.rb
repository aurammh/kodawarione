# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include Accessible
  skip_before_action :check_path, only: :destroy
  before_action :set_user_type, only: [:new, :create, :sign_in_sign_up]

  @@type = 0

  #this function is called from other Class
  def self.set_userType(data)
    @@type = data
  end

  #set data for global user_type
  @@active_flag = false
  #this function is called from other Class
  def self.set_activeFlag(flag)
    @@active_flag = flag
  end

  def self.get_activeFlag
    @@active_flag
  end
  #GET /resource/sign_in
  # def new
  #   super
  # end

  ##POST /resource/sign_in
  # def create
  #   super
  # end

  def sign_in_sign_up
      @user = User.new
  end

  def check_user_mail
    user = User.new(user_email_param)
    check_user_email = User.find_by(email: user.email)
    if check_user_email.present?
      redirect_to user_session_path(email: user.email)
    else
      redirect_to new_user_registration_path(email: user.email)
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super do 
      flash.clear
    end
  end

  # protected
  
  # If you have extra params to permit, append them to the sanitizer. 
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def set_user_type
    @user_type = @@type
  end 

  def user_email_param
    params.require(:user).permit(:email)
  end
  
end
