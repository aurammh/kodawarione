class Company::CompaniesController < ApplicationController
  before_action :authenticate_company_user!,  except: %i[ company_genuine_password company_genuine_password_change new create ]
  before_action :set_user_company, only: %i[ edit update index destroy create ]
  before_action :set_setting_company, only: %i[ company_setting company_setting_update]
  before_action :set__company_user_token, only: %i[ company_genuine_password company_genuine_password_change ]
  load_and_authorize_resource except: %i[:new :create :company_genuine_password :company_genuine_password_change :company_setting :company_setting_update], param_method: :company_company_params
  include CommonHelper
  include Student::AssessmentsHelper
  # GET /company/companies or /company/companies.json
  def index
    # set previous path for breadcrumbs
    cookies[:previous_url] = '/company/companies'
    #for dashboard favourite list
    @favourite_users_list = Company::Company.new.get_favourite_list(current_company.id).limit(4)
    @favourite_users_list_count = Company::Company.new.get_favourite_list(current_company.id).size
  
    #for show created vacancy list 
    @company_vacancies = Company::Company.new.get_vacancy_list(current_company.id).limit(4)
    @company_vacancies_count = Company::Company.new.get_vacancy_list(current_company.id).size
    @company_vacancies_this_week_count = Company::Company.new.get_vacancy_list(current_company.id).where(created_at: DateTime.now.beginning_of_week .. DateTime.now).size

    # get event entry list
    @event_entry_list = Company::Company.new.get_event_entry_list(current_company.id).limit(4)
  @event_entry_list_count = Company::Company.new.get_event_entry_list(current_company.id).size
    @event_entry_list_this_week_count = Company::Company.new.get_event_entry_list(current_company.id).where(created_at: DateTime.now.beginning_of_week .. DateTime.now).size
    @student_join_event = Company::Company.new.get_join_event_student_count(current_company.id).limit(4)

    #get company scouted result count
    @scouted_result_count = Company::Company.new.get_scouted_result_count(current_company.id) 

    #get applied_job_approval_list_count
    @applied_job_approval_list_count = Company::Company.new.get_applied_job_approval_list_count(current_company.id) 

    # get admin event entry list
    @admin_event_entry_list =Event.joins(:admin_event_participants).where("admin_event_participants.company_id =? AND admin_event_participants.delete_flg =? AND events.delete_flg =? ",current_company.id, false, false).select("events.*,count(admin_event_participants.admin_event_id) as join_count").group(:id).order(updated_at: :desc).limit(4)

    @scotted_conversation = (Communication::Communication.new.get_all_communication(0,current_user_data.id,current_company.id, 1 , check_user_type).limit(4)).sort_by(&:created_at).reverse

    @direct_conversation = (Communication::Communication.new.get_all_communication(0,current_user_data.id,current_company.id, 2 , check_user_type)).sort_by(&:created_at).reverse

    # #to check read or not conversation
    new_communication_array

    # get partner-news list
    @partner_news_list = Student::Student.new.get_partner_news_list(3).limit(4)
    
    get_hash_value(@student_join_event)
  end

  #company scouted result list
  def scouted_result
    # set previous path for breadcrumbs
    cookies[:previous_url] = '/company/scouted_result'
    scouted_status_query = ""
    scouted_status_query = params[:scout_status].blank? ? params[:scout_status] = [] : "communications.scout_status = #{params[:scout_status]}" 
    @scouted_result = Company::Company.new.get_scouted_result(current_company.id,[scouted_status_query])  
    @scouted_result = Kaminari.paginate_array(@scouted_result).page(params[:page]).per(12)
    render "communication/communications/list/company_scouted_result_list.html"
  end  

  # GET company/scouted_student_list/:mail_id/student_details/:student_id
  def scouted_student_detail
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
    render "communication/communications/list/company_scouted_student_detail"
  end

  #show all favourite user/student list
  def favourite_student_index
    # set previous path for breadcrumbs
    cookies[:previous_url] = '/company/favourite_student_index'
    @favourite_users_list = Company::Company.new.get_favourite_list(current_company.id)
    @favourite_users_list = Kaminari.paginate_array(@favourite_users_list).page(params[:page]).per(12)
    render "company/companies/list/favourite_student_index"
  end

  # GET /company/companies/new
  def new
    @company_company = Company::Company.new
  end

  # GET /company/companies/1/edit
  def edit
    @genuine_password_flag = false || params[:genuine_password]
  end

  # POST /company/companies or /company/companies.json
  def create
    @company_company = Company::Company.new(company_company_params)
    company_company_user = CompanyUser.find_by_email(@company_company.contact_email)
    company_user_member = Company::CompanyMember.find_by_user_email(@company_company.contact_email)

    # set assigned partner_id
    all_partner = Partner::Partner.select(:partner_code, :id, :name)
    check_param = params[:partner_code].present? ? params[:partner_code] : cookies[:partner_code]
    shared_partner = if check_param.present? && BCrypt::Password.valid_hash?(check_param)
                        all_partner.find { |val| BCrypt::Password.new(check_param) == val.partner_code }
                      else
                        all_partner.first
                      end
    @company_company.partner_id = shared_partner.id
    # set company assigned parter_id 
    # @company_company.partner_id = 1
    if company_company_user.blank?
      
      respond_to do |format|
        if @company_company.save
          company_user = CompanyUser.new
          company_user.email = @company_company.contact_email
          company_user.save(validate: false)
         
          user = CompanyUser.find_by(email: @company_company.contact_email)
          company = Company::Company.find_by(contact_email: @company_company.contact_email, id: @company_company.id)
          company_member = Company::CompanyMember.new
          company_member.user_email = @company_company.contact_email
          company_member.user_id = user.id
          company_member.company_id = company.id
          company_member.join_flag = true
          company_member.company_roles_id = 1
          company_member.save(validate: false)
          # Welcome::CompanyConfirmMailer.with(email: params[:company_company][:contact_email],company_users: company_user, company_name: params[:company_company][:company_name] ).company_confirm_email.deliver_now
          redirect_to(welcome_registration_complete_path) and return
        else
          format.html { render :new }
          format.json { render json: @company_company.errors, status: :unprocessable_entity }
        end
      end
    else
      if company_user_member.blank?
        respond_to do |format|
          if @company_company.save
            user = CompanyUser.find_by(email: @company_company.contact_email)
            #company = Company::Company.find_by(@company_company.id)
            company_member = Company::CompanyMember.new
            company_member.user_email = @company_company.contact_email
            company_member.user_id = user.id
            company_member.company_id = @company_company.id
            company_member.join_flag = true
            company_member.company_roles_id = 1
            company_member.save(validate: false)
            Welcome::CompanyConfirmMailer.with(email: params[:company_company][:email],company_users: company_company_user, company_name: params[:company_company][:company_name]).company_confirm_email.deliver_now
            redirect_to(welcome_registration_complete_path) and return
          else
            format.html { render :new }
            format.json { render json: @company_company.errors, status: :unprocessable_entity }
          end
        end
      else
        # Contact email validaion in compnay member table
        respond_to do |format|
          @company_company.errors.add(:contact_email, " 同じ情報が既に入力されております。")
          format.html { render :new }
          format.json { render json: @company_company.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /company/companies/1 or /company/companies/1.json
  def update    
    respond_to do |format|
      
      if @user_company.update(company_company_params)
        # To delete upload image
        # if params[:company_company][:imageFlag] == "true"
        #   @user_company.image.purge
        # end
        # unless params[:company_company][:image_data].eql?"false"
        #   blob = convert_Base64_imgData(params[:company_company][:image_data])
        #   @user_company.image.attach(blob)
        #   params[:company_company][:image_data] = false
        # end
        format.html { redirect_to edit_company_company_url }
        format.json { render :edit, status: :ok, location: @user_company }
        flash[:success] = [t('common.update_success'), t('common.menu_registration_confirm_screen')]
      else
        format.html { render :edit }
        format.json { render json: @user_company.errors, status: :unprocessable_entity }
        flash[:error] = [t('common.update_error'), t('common.menu_registration_confirm_screen')]
      end
    end
  end

  # DELETE /company/companies/1 or /company/companies/1.json
  def destroy
    @company_company.destroy
    respond_to do |format|
      format.html { redirect_to company_companies_url}
      format.json { head :no_content }
    end
  end

  #set mail setting
  def mail_settings
    @com_info = current_company
    @com_info.update_attribute(:mail_setting, params[:mail_setting].to_i)
    @com_info.save
    render :json => {:status => 'ok', :mail_setting => @com_info.mail_setting}
  end

  def company_setting
    render "company_users/company_user_setting/company_setting"
  end

  def company_setting_update
    @user_company = current_company_user
    flash.clear
    @setting_company.check_update = true
    @setting_company.check_current_password = true 
    @setting_company.check_password = false
    @setting_company.check_email = false 

    @setting_company.check_email = true if company_setting_params[:chk_edit_email] == "1"
    @setting_company.check_password = true if company_setting_params[:chk_pass_edit] == "1" 
    
    if CompanyUser.find(current_company_user.id).valid_password?(company_setting_params[:current_password])   
      respond_to do |format|   
        if  @setting_company.update(company_setting_params)  
            flash[:success] = [t('common.update_success'), t('common.vacancy_registration_confirm_screen')]         
            format.html { redirect_to company_setting_path(scop_name: LogoutHistory.active_types["user"].to_i ? "student" : "company")}
            format.json { head :no_content } 
        else    
            flash[:password] = @setting_company.errors.full_messages_for(:password)[0]
            flash[:password_confirmation] = "新しいパスワードとパスワードの確認入力が一致しません。" 
            flash[:first_name] = "名（漢字） 無効です。"  if company_setting_params[:first_name].blank?  
            flash[:last_name] =  "姓（漢字） 無効です。"  if company_setting_params[:last_name].blank? 
            format.html { render "company_users/company_user_setting/company_setting" }
            format.json { render json: @setting_company.errors, status: :unprocessable_entity }
        end           
      end
    else
      respond_to do |format|
        @setting_company.assign_attributes(company_setting_params)
        @setting_company.valid?
        @setting_company.errors.add(:current_password, t("errors.messages.is_wrong"))
        flash[:first_name] = "名（漢字） 無効です。"  if company_setting_params[:first_name].blank?  
        flash[:last_name] =  "姓（漢字） 無効です。"  if company_setting_params[:last_name].blank? 
        flash[:password] = @setting_company.errors.full_messages_for(:password)[0]if company_setting_params[:password].blank?
        flash[:password_notice] = @setting_company.errors.full_messages_for(:current_password)[0] if company_setting_params[:current_password].blank?       
        format.html { render "company_users/company_user_setting/company_setting" }
        format.json { render json: @setting_company.errors, status: :unprocessable_entity }
      end
    end 
  end

  def company_genuine_password
    if @setting_user.encrypted_password.blank?
      render "company_users/company_user_setting/genuine_password"
    else
      redirect_to root_path
    end
  end

  def company_genuine_password_change
    @setting_user.check_password = true 
    respond_to do |format|
      if @setting_user.update(company_genuine_password_params)
        sign_in(@setting_user)        
          company = Company::Company.find_by(id: @setting_user.company_member.company_id)
          if @setting_user.confirmation_sent_at.present?
            format.html {redirect_to(edit_company_company_commitment_path(company.id))}
          else
            format.html {redirect_to company_companies_path }
          end
        format.json { head :no_content }
      else
        format.html { render "company_users/company_user_setting/genuine_password" }
        format.json { render json: @setting_user.errors, status: :unprocessable_entity }
      end
    end
  end

  #favourite_student_list for multiple communication
  def favourite_student_list
    cookies[:previous_url] = '/company/favourite_student_list'
    @favourite_users_list = Company::Company.new.get_favourite_list(current_company.id)
    @favourite_users_list = Kaminari.paginate_array(@favourite_users_list).page(params[:page]).per(12)
    render "company/companies/list/favourite_student_list"
  end

  #applied_student_list for multiple communication
  def applied_student_list  
    @applied_users_list = Company::Vacancy.new.get_applied_list(current_company.id , "")
    @applied_users_list = Kaminari.paginate_array(@applied_users_list).page(params[:page]).per(12)
      render "company/companies/list/applied_student_list"
  end

  #Applied Job Approval List
  def applied_job_approval_list
    cookies[:previous_url] = '/company/applied_job_approval_list'
    apply_status_query = ""
    apply_status_query = params[:apply_status].blank? ? params[:apply_status] = [] : "vacancy_apply_favourites.apply_status = #{params[:apply_status]}" 
    @applied_job_approval_list = Company::Company.new.get_applied_job_approval_list(current_company.id,[apply_status_query])
    @applied_job_approval_list = Kaminari.paginate_array(@applied_job_approval_list).page(params[:page]).per(12)
    render "company/companies/list/applied_job_approval_list"
  end

  # Get all partner news list
  def partner_news_index
    @all_partner_news_list = Student::Student.new.get_partner_news_list(3)
    @all_partner_news_list = Kaminari.paginate_array(@all_partner_news_list).page(params[:page]).per(12)
    render 'company/companies/list/partner_news_list'
  end

  # Get partner news detail
  def partner_news_detail
    @partner_news = Student::Student.new.get_partner_news(params[:id])
  end
  
  private 

  # Use callbacks to share common setup or constraints between actions.
  def set_user_company
    @user_company = @user_data
  end

  def set_setting_company
    @setting_company = current_company_user
  end

  def set__company_user_token
    @setting_user = CompanyUser.confirm_by_token(params[:confirmation_token])
  end

  def company_genuine_password_params
    params.require(:company_user).permit(:password, :password_confirmation,:confirmation_token ,:first_name ,:last_name)
  end
    
    # Only allow a list of trusted parameters through.
    def company_company_params
      # params.require(:company_company).permit(:partner_id, :m_industry_id, :company_info, :job_info, :capital_amount, :employee_count, :sales_amount,
      #         :related_company, :main_bank, :history, :basic_idea, :representative, :contact, :transportation_facilities,
      #         :company_name, :company_name_kana, :phone_no, :postal_code, :m_prefecture_id, :postalcode_city, :address,
      #         :display_address, :company_established, :company_intro, :website_url, :company_message, 
      #         :other_message, :experience_requirements, :fresher_requirements, :fresher_second_requirements, :company_vision_mission, 
      #         :what_we_do, :how_we_do, :about_our_team, :member_message, :mail_setting, :contact_email, :created_user_id,
      #         :updated_user_id, :image, :progress_details, :progress_complete)
      params.require(:company_company).permit(:capital_amount, :sales_amount,
              :related_company, :main_bank, :basic_idea, :representative, :contact, :transportation_facilities, :email, :company_name, :contact_email, :not_company_edit)
      # params.require(:company_company).permit(:partner_id, :email, :company_name, :company_name_kana, :postal_code, :user_name, :contact_email,
      #   :address, :display_address, :phone_no, :m_industry_id,:company_info, :image, :website_url, :postalcode_city, :m_prefecture_id, :prefecture_name ,:company_established, :job_info, :contact, :capital_amount, :employee_count, :sales_amount, :related_company, :representative, :main_bank, :history, :transportation_facilities,:avg_service_year, :avg_overtime_per_month, :avg_paid_leaves,:number_eligible_childcare_leaves_male,:taken_childcare_leaves_male,:childcare_leave_acquisition_rate_male,:number_eligible_childcare_leaves_female,:taken_childcare_leaves_female,:rate_taken_childcare_leaves_female,:basic_idea,:percentage_female_ration,:percentage_training,:mentor_system,:career_consulting_system,:in_house_certification_system,:capital_amount_string,:sales_amount_string)
    end
    def company_setting_params
      params.require(:company_user).permit(:email, :chk_edit_email, :password, :password_confirmation, :current_password, :chk_pass_edit,:first_name ,:last_name)
    end
end