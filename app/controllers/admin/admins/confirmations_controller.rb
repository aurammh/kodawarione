# frozen_string_literal: true

class Admin::Admins::ConfirmationsController < Devise::ConfirmationsController
    layout 'layouts/template/kodawarione'
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
            respond_with_navigational(resource){ redirect_to admin_genuie_password_path(confirmation_token: resource.confirmation_token) }
        else
            if resource.genuine_password == false
                respond_with_navigational(resource.errors, status: :unprocessable_entity){redirect_to(admin_genuie_password_path(confirmation_token: resource.confirmation_token)) } 
            else
                respond_with_navigational(resource.errors, status: :unprocessable_entity){redirect_to(admin_session_path) }
            end
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
  