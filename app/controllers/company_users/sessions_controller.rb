# frozen_string_literal: true

class CompanyUsers::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  include Accessible
  skip_before_action :check_path, only: :destroy
  #set data for global user_type
  @@active_flag = false
  #this function is called from other Class
def self.set_activeFlag(flag)
  @@active_flag = flag
end

def self.get_activeFlag
  @@active_flag
end
  # GET /resource/sign_in
  def new
    super do
      resource.email = params[:email]
    end
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
