class Kodawarione::CompanyManage::CompanyController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_company, only: %i[ edit_commitment update_commitment edit_company update_company company_details_overview company_details_basic_info company_details_company_page company_details_activity_page favourite_student_list join_event_list company_event_list company_vacancy_list]
  authorize_resource class: 'Kodawarione::CompanyManage'
  layout 'layouts/template/kodawarione'

  include CommonHelper
  include  Kodawarione::CompanyManage::CompanyHelper

  def company_search
      startDate = params[:startDate].blank? ? nil : params[:startDate]
      keyword = params[:keyword].blank? ? nil : params[:keyword].strip
      endDate = params[:endDate].blank? ? nil : params[:endDate]
      @vacancy_status = Company::Vacancy.select(:company_id).distinct.map{|data| data.company_id}
      @event_status = Event.select(:created_by_id).distinct.map{|data| data.created_by_id}
      if startDate.blank? && !endDate.blank?
        @result_list = Company::Company.admin_search_by_only_end_date(endDate, keyword).where(query_with_current_role("companies", "company_search"))
      elsif(!startDate.blank? && endDate.blank?)
        @result_list = Company::Company.admin_search_by_only_start_date(startDate, keyword).where(query_with_current_role("companies", "company_search"))
      elsif(!startDate.blank? && !endDate.blank?)
        @result_list = Company::Company.admin_search_by_between_two_date(startDate, endDate, keyword).where(query_with_current_role("companies", "company_search"))
      else
        @result_list = Company::Company.admin_company_all_init_list(keyword).where(query_with_current_role("companies", "company_search"))
      end 
      @results = Kaminari.paginate_array(@result_list).page(params[:page]).per(12)
  end

  def edit_commitment
  end

  def update_commitment
    respond_to do |format|
      if @company_details.update(company_commitment_params)     
        format.html { redirect_to  kodawarione_company_manage_edit_commitment_path}            
        flash[:success] = [t('common.update_success'), t('student_commitment.title.student_commitment_title')]
      else       
        format.html { render :edit_commitment }
        flash[:error] = [t('common.update_error'), t('student.assessment.kodawari_assessment_title')]
      end
    end
  end

  def edit_company 
  end

  def update_company 
    respond_to do |format|
      if @company_details.update(company_company_params)
        format.html { redirect_to kodawarione_company_manage_edit_path }
        flash[:success] = [t('common.update_success'), t('common.menu_registration_confirm_screen')]
      else
        format.html { render :edit_company }
        flash[:error] = [t('common.update_error'), t('common.menu_registration_confirm_screen')]
      end
    end
  end

  def company_details_overview
  end

  def company_details_basic_info
  end

  def company_details_company_page
  end

  def company_details_activity_page
    @company_activities = Company::Activity.where(company_id: @company_details.id).order("created_at desc")
    @company_interview_story_lists = Company::InterviewStory.where(:company_id => @company_details.id).order("created_at desc")
  end

   #show all favourite user/student list
   def favourite_student_list
    @favourite_users_list = Company::Company.new.get_favourite_list(params[:company_id])
    @favourite_users_list = Kaminari.paginate_array(@favourite_users_list).page(params[:page]).per(12)
  end
  
  #Get admin event list 
  def join_event_list
    @admin_event_result = Event.joins(:admin_event_participants).where("admin_event_participants.company_id =? AND admin_event_participants.delete_flg =? AND events.delete_flg =?",params[:company_id], false,false).select("events.*, count(admin_event_participants.admin_event_id) as join_count").group(:id).order(updated_at: :desc)
    @admin_event_result = Kaminari.paginate_array(@admin_event_result).page(params[:page]).per(12)
  end

  #Get company event list 
  def company_event_list
    @company_events = Company::Company.new.get_event_entry_list(params[:company_id])
    @company_events = Kaminari.paginate_array(@company_events).page(params[:page]).per(12)
  end

  #Get company vacancy list 
  def company_vacancy_list
    @company_vacancies = Company::Company.new.get_vacancy_list(params[:company_id])
    @company_vacancies = Kaminari.paginate_array(@company_vacancies).page(params[:page]).per(12)
  end

  private 

  def set_admin_company
    @company_details = Company::Company.select('companies.*,m_industries.industry_name').left_outer_joins(:m_industries).find(params[:company_id])
    @open_jobs_count = Company::Vacancy.where("company_id = ? AND published_flg = ? AND CURRENT_DATE BETWEEN display_from AND display_to", @company_details.id, true).size
    @events_count = Event.where("created_by_id = ? AND event_type = ? AND delete_flg = ?", @company_details.id, 1, false).size
    @members_list = Company::CompanyMember.select('company_members.*,company_users.first_name, company_users.last_name,company_roles.role_type').left_outer_joins(:company_users).left_outer_joins(:company_roles).where("company_members.company_id = ? AND join_flag = ? AND NOT user_id = ? AND company_users.last_name IS NOT NULL",@company_details.id,true, @company_details.id).order("company_roles.id") 
    @favourite_users_list = Company::Company.new.get_favourite_list(params[:company_id]).limit(4)
    @admin_event_entry_list =Event.joins(:admin_event_participants).where("admin_event_participants.company_id =? AND admin_event_participants.delete_flg =? AND events.delete_flg =? ",params[:company_id], false, false).select("events.*,count(admin_event_participants.admin_event_id) as join_count").group(:id).order(updated_at: :desc).limit(4)
    @event_entry_list = Company::Company.new.get_event_entry_list(params[:company_id]).limit(4)
    @company_vacancies = Company::Company.new.get_vacancy_list(params[:company_id]).limit(4)
    if current_admin.super_partner?
      redirect_to(kodawarione_company_manage_company_search_path) unless  get_query_partner_list_with_super_partner_id.include?(@company_details.partner_id)
    elsif current_admin.partner?
      redirect_to(kodawarione_company_manage_company_search_path) unless  @company_details.partner_id == current_admin.admin_member.partners_id
    end
  end

  def company_commitment_params
    params.require(:company_company).permit(:company_name, :company_name_kana, :partner_id, :postal_code,
    :m_prefecture_id, :prefecture_name, :postalcode_city, :address, :m_region_id, :region_name, :display_address,:phone_no, :website_url,:company_established,:not_company_edit)
  end

  def company_company_params
    params.require(:company_company).permit(:capital_amount, :sales_amount,
            :related_company, :main_bank, :basic_idea, :representative, :contact, :transportation_facilities, :email, :company_name, :contact_email, :not_company_edit)
  end
end