class Admin::CompanyManage::CompanyController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_company, only: %i[ company_edit company_update company_delete]

  include CommonHelper
  layout 'layouts/template/admin'

  def company_search
    startDate = params[:startDate].blank? ? nil : params[:startDate]
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    endDate = params[:endDate].blank? ? nil : params[:endDate]
    @vacancy_status = Company::Vacancy.select(:company_id).distinct.map{|data| data.company_id}
    @event_status = Event.select(:created_by_id).distinct.map{|data| data.created_by_id}
    if startDate.blank? && !endDate.blank?
      @result_list = Company::Company.admin_search_by_only_end_date(endDate, keyword)  
    elsif(!startDate.blank? && endDate.blank?)
      @result_list = Company::Company.admin_search_by_only_start_date(startDate, keyword)
    elsif(!startDate.blank? && !endDate.blank?)
      @result_list = Company::Company.admin_search_by_between_two_date(startDate, endDate, keyword) 
    else
      @result_list = Company::Company.admin_company_all_init_list(keyword)
    end 
    @results = Kaminari.paginate_array(@result_list).page(params[:page]).per(12)

    respond_to do |format|
      format.html
      format.xlsx { render xlsx: t('search.excel_file_name'), template: 'admin/excel_template/company_excel_export'}
    end
  end

  def company_details
    @company_details = Company::Company.select('companies.*,m_industries.industry_name').left_outer_joins(:m_industries).find(params[:company_id])
    @this_company_event_list = Event.where(created_by_id: params[:company_id], event_type:1, delete_flg: false).order(created_at: :desc)
  end
  

  def company_edit
  end

  def company_update    
    respond_to do |format|
      if @user_company.update(company_params)
        # To delete upload image
        if params[:company_company][:imageFlag] == "true"
          @user_company.image.purge
        end
        unless params[:company_company][:image_data].eql?"false"
          blob = convert_Base64_imgData(params[:company_company][:image_data])
          @user_company.image.attach(blob)
          params[:company_company][:image_data] = false
        end
        format.html { redirect_to admin_company_manage_company_details_path(company_id: @user_company.id ,:status => params[:status])}
        format.json { render :show, status: :ok, location: @user_company }
      else
        format.html { render :company_edit }
        format.json { render json: @user_company.errors, status: :unprocessable_entity }    
      end
    end
  end

  def company_delete
    @user_company.update_columns(delete_flg: true)
    @user_company.events.update_all(delete_flg: true)
    @user_company.company_vacancies.update_all(delete_flg: true)
    @user.update(delete_flg: true)
    if params[:status] == "1"
      redirect_to admin_company_manage_company_search_path      	 
    else
      redirect_to admin_admin_company_setting_path
    end
  end

  def admin_company_setting
    name = params[:company_name].blank? ? nil : params[:company_name].strip
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    results = Company::Company.admin_setting_company_all_init_list(name, keyword)
    @results = Kaminari.paginate_array(results).page(params[:page]).per(12)
  end

  def set_permission
    permission = Admin::Permission.find_by(admin_permission_type_id: params[:type_id], company_id: params[:company_id])
    if permission.present?
      Admin::Permission.transaction do
        permission.destroy
      end
    else
      Admin::Permission.transaction do
        permis_data = Admin::Permission.new
        permis_data.admin_permission_type_id = params[:type_id]
        permis_data.company_id = params[:company_id]
        permis_data.create_user = "#{current_admin.first_name} #{current_admin.last_name}"
        permis_data.user_type = 2
        permis_data.ip_address = request.ip 
        permis_data.save!
      end
    end
  end

  def company_user_lists
    company_id = params[:company_id]
    admin_company_id = params[:admin_company_id]
    name = params[:company_name].blank? ? nil : params[:company_name].strip
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    @permission_type = Admin::MPermissionType.where(use_company: true, id: 1)
    @permissions = Admin::Permission.select("admin_permissions.admin_permission_type_id ,admin_permissions.company_user_id as user_id").where(user_type: 2, admin_permission_type_id: 1, user_id: nil)

    if company_id.present?
      results = CompanyUser.admin_company_user_lists_by_company_id(company_id)
    elsif admin_company_id.present?
      results = CompanyUser.admin_company_user_lists_by_admin_company_id(admin_company_id, keyword, name)
    end
    @company_user_lists = Kaminari.paginate_array(results).page(params[:page]).per(12)
  end

  def company_user_set_permission
    permission = Admin::Permission.find_by(admin_permission_type_id: params[:type_id], company_id: params[:company_id], company_user_id: params[:company_user_id])
    if permission.present?
      Admin::Permission.transaction do
        permission.destroy
      end
    else
      Admin::Permission.transaction do
        permis_data = Admin::Permission.new
        permis_data.admin_permission_type_id = params[:type_id]
        permis_data.company_id = params[:company_id]
        permis_data.company_user_id = params[:company_user_id]
        permis_data.create_user = "#{current_admin.first_name} #{current_admin.last_name}"
        permis_data.user_type = 2
        permis_data.ip_address = request.ip 
        permis_data.save!
      end
    end
  end

  def favourite_company
    @favourite_company_list = Company::Company.new.show_top_3_fav_company()
  end

  private
  def set_admin_company
    @user_company = Company::Company.find(params[:id])
    @user = CompanyUser.joins(:company_member).where("company_members.join_date IS NULL and company_members.company_roles_id = 1 and company_members.company_id = ? ", params[:id]).take
  end

  def company_params
    params.require(:company_company).permit(:email, :company_name, :company_name_kana, :postal_code, :user_name,
      :address, :display_address, :phone_no, :m_industry_id,:company_info, :image, :website_url, :postalcode_city, :m_region_id, :region_name, :m_prefecture_id, :prefecture_name ,:company_established, :job_info, :contact, :capital_amount, :employee_count, :sales_amount, :related_company, :representative, :main_bank, :history, :transportation_facilities,:avg_service_year, :avg_overtime_per_month, :avg_paid_leaves,:number_eligible_childcare_leaves_male,:taken_childcare_leaves_male,:childcare_leave_acquisition_rate_male,:number_eligible_childcare_leaves_female,:taken_childcare_leaves_female,:rate_taken_childcare_leaves_female,:basic_idea,:percentage_female_ration,:percentage_training,:mentor_system,:career_consulting_system,:in_house_certification_system,:avg_service_year_string,:capital_amount_string,:sales_amount_string)
  end
end