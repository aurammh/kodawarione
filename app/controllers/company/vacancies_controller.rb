class Company::VacanciesController < ApplicationController
  before_action :authenticate_company_user!
  before_action :set_company_vacancy, only: %i[ show edit update destroy apply_accept apply_reject ]
  load_and_authorize_resource param_method: :company_vacancy_params
  
  include CommonHelper
  include Student::AssessmentsHelper
  # GET /company/vacancies or /company/vacancies.json
  def index
    # set previous path for breadcrumbs
    cookies[:previous_url] = '/company/vacancies'
    @company_vacancies =  Company::Company.new.get_vacancy_list(current_company.id)
    @company_vacancies = Kaminari.paginate_array(@company_vacancies).page(params[:page]).per(12)
  end

  # GET /company/vacancies/1 or /company/vacancies/1.json
  def show
    @company_vacancy_list = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name')
    .joins(:m_industries,:m_occupations).where("company_vacancies.id = ? and company_vacancies.company_id = ?", params[:id], current_company.id).take
    
    if @company_vacancy_list.present?
      @welfare_list =
      if @company_vacancy_list.welfare_list_data.present?
        welfare_list = @company_vacancy_list.welfare_list_data.select { |item| nil != item}
        welfare_data_index =  welfare_list.each_index.select { |i| welfare_list[i]== 1 }.map!{|element| element.is_a?(Integer) ? element + 1 : element}
        if welfare_data_index.any?
          #MWelfareDetail.where("id IN (#{welfare_data_index.join(',')})").map { |wf| [wf.welfare_type]}.join(', ')
          MWelfareDetail.where("id IN (#{welfare_data_index.join(',')})")
        end
      end 

      #get apply vacancy list by student (status)
      apply_status_query = ""
      apply_status_query = params[:apply_status].blank? ? params[:apply_status] = [] : "vacancy_apply_favourites.apply_status = #{params[:apply_status]}"  
      @applied_student_list = Company::Vacancy.new.get_applied_list(current_company.id,@company_vacancy_list.id,[apply_status_query]).limit(5)   
    else
      redirect_to company_vacancies_path
    end

    #get favorite vacancy list by student
    unless check_user_type == LogoutHistory.active_types["company"].to_i
      favorite_vacancy = @company_vacancy_list.vacancy_apply_favourites.where(favourite_flg: true,student_id: current_user.student.id)
      @fav_vacancy = favorite_vacancy.present? ? true :false
    end
     #get apply vacancy list by student
     unless check_user_type == LogoutHistory.active_types["company"].to_i
      apply_vacancy = @company_vacancy_list.vacancy_apply_favourites.where(apply_flg: true,student_id: current_user.student.id)
      @apply_vacancy = apply_vacancy.present? ? true :false
    end
 
  end

  #company accept student apply vacancy
  def apply_accept 

    #find vacancy id for status == 1
    @applied_student_list = VacancyApplyFavourite.find_by(company_vacancy_id: params[:id])

    #update vacancy_apply_favourite column(status)
    @applied_student_list.update_attribute(:apply_status,2) 
    #update vacancy_apply_favourite column(apply_status_date)
    @applied_student_list.update_attribute(:apply_status_date,Date.today) 

    create_application_status(@applied_student_list.student_id,@applied_student_list.company_id,0,@applied_student_list.id,1,2)

    redirect_to company_vacancy_applied_student_list_path(:id => @applied_student_list.company_vacancy_id)
  end

  #company reject student apply vacancy
  def apply_reject
    @applied_student_list = VacancyApplyFavourite.find_by(company_vacancy_id: params[:id])
    @applied_student_list.update_attribute(:apply_status,3)
    redirect_to company_vacancy_applied_student_list_path(:id => @applied_student_list.company_vacancy_id)
  end

  #get vacancy_applied_student_list for Accept/Denies , Status
  def vacancy_applied_student_list 
      apply_status_query = ""
      apply_status_query = params[:apply_status].blank? ? params[:apply_status] = [] : "vacancy_apply_favourites.apply_status = #{params[:apply_status]}"  
      @company_vacancy_list = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name')
      .joins(:m_industries,:m_occupations).where("company_vacancies.id = ? and company_vacancies.company_id = ?", params[:id], current_company.id).take
      @vacancy_applied_student_list = Company::Vacancy.new.get_applied_list(current_company.id,@company_vacancy_list.id,[apply_status_query])  
      @vacancy_applied_student_list = Kaminari.paginate_array(@vacancy_applied_student_list).page(params[:page]).per(12)
      render "company/vacancies/list/vacancy_applied_student_list"
  end

  # GET /vacancy_applied_student_list/1/student_details/1
  def vacancy_applied_student_detail
    @company_vacancy_list = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name')
    .joins(:m_industries,:m_occupations).where("company_vacancies.id = ? and company_vacancies.company_id = ?", params[:vacancy_id], current_company.id).take
    @progress_percent_arr = current_company.progress_details.map {|obj| obj['percent']}
    @student_info = Student::Student.select('students.*,apply_favourite_transictions.company_id,apply_favourite_transictions.com_std_favourite').left_joins(:apply_favourite_transictions).find(params[:student_id])
    @student_assessment = Student::Assessment.find_by(student_id: params[:student_id])
    have_fav_student = ApplyFavouriteTransiction.find_by(student_id: @student_info.id, company_id: current_company.id)
    @fav_student = have_fav_student.nil? ? false : have_fav_student.com_std_favourite
    @student_apply_status = VacancyApplyFavourite.where('company_id = ? and student_id = ? and apply_status = ? ', current_company.id, @student_info.id, 2)
    selfEevaluationChart_rank(@student_assessment)
    #call radar chart two function
    potentialDesireType(@student_assessment)
    #call third function
    behavioralTraitTypeChart_rank(@student_assessment)
    render "company/vacancies/list/vacancy_applied_student_detail"
  end
  
  # GET /company/vacancies/new
  def new
    #permission_url
    @company_vacancy = Company::Vacancy.new
    @company_postal_address = Company::Company.select("companies.postal_code,companies.postalcode_city,companies.m_prefecture_id,companies.m_region_id,companies.address").where(id: current_company.id).take
    @copy_postal_address_btn = true
  end

  # GET /company/vacancies/1/edit
  def edit
    @copy_postal_address_btn = false
  end

  # POST /company/vacancies or /company/vacancies.json
  def create
    @company_vacancy = Company::Vacancy.new(company_vacancy_params)
    @company_vacancy.company_id = current_company.id
    #convert json data type to array
    com_enhancement = getJsonKey(params[:company_vacancy][:company_enhancement])
    welfare_list = getJsonKey(params[:company_vacancy][:welfare_list_data])
    @company_vacancy.company_enhancement = com_enhancement
    @company_vacancy.welfare_list_data = welfare_list
    respond_to do |format|
      if @company_vacancy.save
        format.html { redirect_to @company_vacancy}
        format.json { render :show, status: :created, location: @company_vacancy }
        flash[:success] = [t('common.create_success'), t('common.vacancy_registration_confirm_screen')]
      else
        @company_postal_address = Company::Company.select("companies.postal_code,companies.postalcode_city,companies.m_prefecture_id,companies.m_region_id,companies.address").where(id: current_company.id).take
        @copy_postal_address_btn = true
        format.html { render :new }
        format.json { render json: @company_vacancy.errors}
        flash[:error] = [t('common.create_error'), t('common.vacancy_registration_confirm_screen')]
      end
    end
  end

  # PATCH/PUT /company/vacancies/1 or /company/vacancies/1.json
  def update
    #convert json data type to array
    com_enhancement = getJsonKey(params[:company_vacancy][:company_enhancement])
    welfare_list = getJsonKey(params[:company_vacancy][:welfare_list_data])
    @company_vacancy.company_enhancement = com_enhancement
    @company_vacancy.welfare_list_data = welfare_list
    respond_to do |format|
      if @company_vacancy.update(company_vacancy_params)
        format.html { redirect_to @company_vacancy }
        format.json { render :show, status: :ok, location: @company_vacancy }
        flash[:success] = [t('common.update_success'), t('common.vacancy_registration_confirm_screen')]
      else
        format.html { render :edit }
        format.json { render json: @company_vacancy.errors}
        flash[:error] = [t('common.update_error'), t('common.vacancy_registration_confirm_screen')]
      end
    end
  end

  # DELETE /company/vacancies/1 or /company/vacancies/1.json
  def destroy
    @company_vacancy.destroy
    respond_to do |format|
      format.html { redirect_to company_vacancies_url}
      format.json { head :no_content }
    end
  end

  private
  def permission_url
    unless check_permission?(current_user.id,'vacancy_create')
      redirect_to company_companies_path
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_company_vacancy
      @company_vacancy = Company::Vacancy.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_vacancy_params
      #params.fetch(:company_vacancy, {})
      params.require(:company_vacancy).permit(:company_id, :vacancy_code , :vacancy_title, :vacancy_description , :postal_code, :postalcode_city, :m_region_id, :region_name, :m_prefecture_id, :prefecture_name, :address, :display_address,
        :recruit_industry_type, :recruit_job_type, :required_applicants, :basic_salary, :promotion , :allowance, :bonus, :probation, :transportation_allowance, :dormitory, :insurance, :severance_pay, :other, :working_hours, :break_time, 
        :over_time, :holiday, :display_from, :display_to,:other_skill, :published_flg, :required_applicants_string,:basic_salary_string, :hiring_flow_data => [], :company_enhancement => [], :welfare_list_data => [])
    end
end
