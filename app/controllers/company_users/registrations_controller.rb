# frozen_string_literal: true

class CompanyUsers::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  #GET /resource/sign_up
  def new
    @confirm_member_token = params[:confirm_member_token]
    company_name = ""
    com_member = Company::CompanyMember.find_by(confirmation_token: @confirm_member_token)
        if com_member.present?
          company_name = Company::Company.find(com_member.company_id).company_name
        end
    super do
    resource.email = params[:email]
    resource.company_name = company_name
    end
  end

  # POST /resource
  def create
    super do
      if resource.save
        com_member = Company::CompanyMember.find_by(confirmation_token: params[:company_user][:confirm_member_token])
        if com_member.present?
          com_member.update(user_id: resource.id)	
        else
          resource.destroy
        end
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      # devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email,:password,  :last_name,:first_name,:company_name])
      #:confirm_member_token
    end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    welcome_registration_complete_path
    # super(resource)
  end
end
