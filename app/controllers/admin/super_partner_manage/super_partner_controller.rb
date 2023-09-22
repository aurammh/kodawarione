class Admin::SuperPartnerManage::SuperPartnerController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_super_partner, only: %i[ company_edit company_update company_delete]

  include CommonHelper
  layout 'layouts/template/admin'

  def admin_super_partner_setting
    code = params[:code].blank? ? nil : params[:code].strip
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    results = Admin::SuperPartner.admin_setting_super_partner_all_init_list(code, keyword)
    @results = Kaminari.paginate_array(results).page(params[:page]).per(12)
  end

  def set_permission
    permission = Admin::Permission.find_by(admin_permission_type_id: params[:type_id], super_partner_id: params[:super_partner_id])
    if permission.present?
      Admin::Permission.transaction do
        permission.destroy
      end
    else
      Admin::Permission.transaction do
        permis_data = Admin::Permission.new
        permis_data.admin_permission_type_id = params[:type_id]
        permis_data.super_partner_id = params[:super_partner_id]
        permis_data.create_user = "#{current_admin.first_name} #{current_admin.last_name}"
        permis_data.user_type = 4
        permis_data.ip_address = request.ip 
        permis_data.save!
      end
    end
  end

  def super_partner_user_lists
    super_partner_id = params[:super_partner_id]
    name = params[:name].blank? ? nil : params[:name].strip
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    @permission_type = Admin::MPermissionType.where(use_company: true, id: 1)
    @permissions = Admin::Permission.select("admin_permissions.admin_permission_type_id ,admin_permissions.super_partner_id as user_id").where(user_type: 4, admin_permission_type_id: 1, user_id: nil,company_id:nil,partner_id:nil)
    results = SuperPartnerUser.admin_super_user_lists_by_id(super_partner_id, keyword, name)
    @user_lists = Kaminari.paginate_array(results).page(params[:page]).per(12)
  end

  def super_partner_user_set_permission
    permission = Admin::Permission.find_by(admin_permission_type_id: params[:type_id], super_partner_id: params[:super_partner_id], super_partner_user_id: params[:super_partner_user_id])
    if permission.present?
      Admin::Permission.transaction do
        permission.destroy
      end
    else
      Admin::Permission.transaction do
        permis_data = Admin::Permission.new
        permis_data.admin_permission_type_id = params[:type_id]
        permis_data.super_partner_id = params[:super_partner_id]
        permis_data.super_partner_user_id = params[:super_partner_user_id]
        permis_data.create_user = "#{current_admin.first_name} #{current_admin.last_name}"
        permis_data.user_type = 4
        permis_data.ip_address = request.ip 
        permis_data.save!
      end
    end
  end
end