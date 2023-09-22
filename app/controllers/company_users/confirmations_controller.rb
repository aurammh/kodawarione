# frozen_string_literal: true

class CompanyUsers::ConfirmationsController < Devise::ConfirmationsController
  before_action :member_email_update,  only: %i[ show ]
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?
    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)
      respond_with_navigational(resource){ redirect_to company_genuine_password_path(confirmation_token: resource.confirmation_token) }
    else
      # set_flash_message!(:notice, "#{resource.errors.full_messages}")
      #Users::SessionsController.set_userType(resource.user_type.to_s)
      if resource.encrypted_password.blank?
        respond_with_navigational(resource.errors, status: :unprocessable_entity){redirect_to(company_genuine_password_path(confirmation_token: resource.confirmation_token)) } 
      else
        respond_with_navigational(resource.errors, status: :unprocessable_entity){redirect_to(company_user_session_path) }
      end
    end
  end

  def member_email_update
    user = CompanyUser.confirm_by_token(params[:confirmation_token])
    company_member = Company::CompanyMember.where(user_id: user.id)
    unless company_member.nil?
      company_member.update_all(user_email: user.email)
    end
  end
  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
