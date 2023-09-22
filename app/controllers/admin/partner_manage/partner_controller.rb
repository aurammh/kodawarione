class Admin::PartnerManage::PartnerController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_partner, only: %i[ company_edit company_update company_delete]

  include CommonHelper
  layout 'layouts/template/admin'

  def admin_partner_setting
    code = params[:code].blank? ? nil : params[:code].strip
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip 
    results = Partner::Partner.admin_setting_partner_all_init_list(code, keyword)
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
        permis_data.user_type = 3
        permis_data.ip_address = request.ip 
        permis_data.save!
      end
    end
  end

  def partner_user_lists
    partner_id = params[:partner_id]
    name = params[:name].blank? ? nil : params[:name].strip
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    @permission_type = Admin::MPermissionType.where(use_company: true, id: 1)
    @permissions = Admin::Permission.select("admin_permissions.admin_permission_type_id ,admin_permissions.partner_user_id as user_id").where(user_type: 3, admin_permission_type_id: 1, user_id: nil,company_id:nil,super_partner_id:nil)
    results = PartnerUser.admin_partner_user_lists_by_id(partner_id, keyword, name)
    @user_lists = Kaminari.paginate_array(results).page(params[:page]).per(12)
  end

  def partner_user_set_permission
    permission = Admin::Permission.find_by(admin_permission_type_id: params[:type_id], partner_id: params[:partner_id], partner_user_id: params[:partner_user_id])
    if permission.present?
      Admin::Permission.transaction do
        permission.destroy
      end
    else
      Admin::Permission.transaction do
        permis_data = Admin::Permission.new
        permis_data.admin_permission_type_id = params[:type_id]
        permis_data.partner_id = params[:partner_id]
        permis_data.partner_user_id = params[:partner_user_id]
        permis_data.create_user = "#{current_admin.first_name} #{current_admin.last_name}"
        permis_data.user_type = 3
        permis_data.ip_address = request.ip 
        permis_data.save!
      end
    end
  end
end