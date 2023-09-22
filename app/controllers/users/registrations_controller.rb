# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :set_user_type, only: [:new, :create]
  after_action :register_by_company, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  #set data for global user_type
  @@type = 0

  #this function is called from other Class
  def self.set_userType(data)
    @@type = data
  end

  # GET /resource/sign_up
  def new
    @confirm_member_token = params[:confirm_member_token]
    super do
      resource.email = params[:email]
    end
  end

  # POST /resource
  def create
      super do
        # set assigned partner_id
        all_partner = Partner::Partner.select(:partner_code, :id, :name)
        check_param = params[:partner_code].present? ? params[:partner_code] : cookies[:partner_code]
        shared_partner = if check_param.present? && BCrypt::Password.valid_hash?(check_param)
                            all_partner.find { |val| BCrypt::Password.new(check_param) == val.partner_code }
                          else
                            all_partner.first
                          end
        resource.partner_id = shared_partner.id

        if resource.save
            student = Student::Student.new
            student.user_id = resource.id
            student.save(validate: false)
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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email,:password, :tnc_and_policy,:confirm_member_token])
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
  
  def set_user_type
    @user_type = @@type
  end 

  def register_by_company
    if Company::CompanyMember.find_by(user_email: @email , confirmation_token: @confirm_member_token).present?
      Company::CompanyMember.find_by(user_email: @email , confirmation_token: @confirm_member_token).update(register_by_company: true, user_id: resource.id) 
    end
  end
end
