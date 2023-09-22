class Kodawarione::SettingController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_admin_setting, only: %i[ kodawari_setting password_update]
    layout 'layouts/template/kodawarione'
    load_and_authorize_resource class: 'Kodawarione::Setting'

    def kodawari_setting 
      render "kodawarione/setting/kodawari_setting"
    end
    
    def password_update
      @admin.check_update = true
      @admin.check_current_password = true 
      @admin.check_password = false
      @admin.check_email = false 
  
      @admin.check_email = true if admin_setting_params[:chk_edit_email] == "1"
      @admin.check_password = true if admin_setting_params[:chk_pass_edit] == "1" 

        if Admin.find(current_admin.id).valid_password?(admin_setting_params[:current_password])
          respond_to do |format|   
            if  @admin.update(admin_setting_params)  
                bypass_sign_in(@admin)
                flash[:password_change] =I18n.t('admin.setting.admin_pwd_change')  
                format.html { redirect_to kodawarione_kodawari_setting_path()}        
                format.json { head :no_content } 
            else    
              format.html {  render "kodawarione/setting/kodawari_setting" }
              format.json { render json: @admin.errors, status: :unprocessable_entity }
            end           
          end 
        else
            respond_to do |format|
                @admin.assign_attributes(admin_setting_params)
                @admin.valid?
                @admin.errors.add(:current_password, t("errors.messages.is_wrong"))
                flash[:password] = @admin.errors.full_messages_for(:password)[0]
                format.html { render "kodawarione/setting/kodawari_setting" }
                format.json { render json: @admin.errors, status: :unprocessable_entity }
              end
        end
    end
    
    def set_permission
      user = User.find(params[:user_id])
      permission = Admin::Permission.find_by(admin_permission_type_id: params[:type_id],user_id: params[:user_id])
      if permission.present?
        Admin::Permission.transaction do
            permission.destroy
        end
      else
        Admin::Permission.transaction do
          permis_data = Admin::Permission.new
          permis_data.admin_permission_type_id = params[:type_id]
          permis_data.user_id = params[:user_id]
          permis_data.create_user = "#{current_admin.first_name} #{current_admin.last_name}"
          permis_data.user_type = user.user_type
          permis_data.ip_address = request.ip 
          permis_data.save!
        end
      end
      
    end

    private

    def set_admin_setting
        @admin = current_admin
    end

    def admin_setting_params
        params.require(:admin).permit(:email, :password, :password_confirmation, :current_password ,:first_name ,:last_name)
    end
end