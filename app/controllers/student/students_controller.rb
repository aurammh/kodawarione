class Student::StudentsController < ApplicationController
  before_action :authenticate_user!, :authorize_user!
  before_action :set_user_student, only: %i[show edit update index destroy]
  include CommonHelper

  def prefecture_name
    prefecture_name_list
  end
  
  # GET /student/students or /student/students.json
  def index
    # set previous path for breadcrumbs
    cookies[:previous_url] = '/student/students'
    # compancy favourite list for dashboard
    @favourite_company_list = Student::Student.new.get_favourite_company_list(current_user.student.id).limit(4)

    # vacancy favourite list for dashboard
    @favourite_vacancy_list = Student::Student.new.get_favourite_vacancy_list(current_user.student.id).limit(4)

    # event posted list for dashboard
    join_company_event_list = Student::Student.new.get_join_company_event_list(current_user.student.id)
    join_admin_event_list = Student::Student.new.get_join_admin_event_lists(current_user.id)
    join_event_lists = join_company_event_list + join_admin_event_list
    @join_event_list = join_event_lists.sort_by(&:event_start_date).reverse.take(4)

    # event favourite list for dashboard
    @favourite_event_list = Student::Student.new.get_favourite_event_list(current_user.student.id).limit(4)

    @scotted_conversation = (Communication::Communication.new.get_all_communication(current_user_data.id,0,0,1, check_user_type).limit(4)).sort_by(&:created_at).reverse

    @direct_conversation = (Communication::Communication.new.get_all_communication(current_user_data.id,0,0,2, check_user_type).limit(4)).sort_by(&:created_at).reverse

    # to check read or not conversation
    new_communication_array
    # get recommended job 
    @recommended_job = Company::Vacancy.select('companies.company_name,company_vacancies.id,company_vacancies.vacancy_title,company_vacancies.display_from,company_vacancies.display_to,company_vacancies.required_applicants,company_vacancies.basic_salary,m_industries.industry_name,m_occupations.occupation_name')
                       .joins(:company,:m_industries,:m_occupations)
                       .where("CURRENT_DATE BETWEEN company_vacancies.display_from AND company_vacancies.display_to AND company_vacancies.published_flg = true AND company_vacancies.delete_flg = false").limit(9)
    # applied job list    
    @applied_job = Company::Vacancy.select("company_vacancies.*,vacancy_apply_favourites.favourite_flg, vacancy_apply_favourites.apply_flg")
            .joins(:vacancy_apply_favourites)
            .where("student_id = #{current_user.student.id} and apply_flg = true").limit(4)

    #joined admin event list for dashboard
    @join_admin_event_list =  Event.joins(:admin_event_participants).where("admin_event_participants.user_id =? AND admin_event_participants.delete_flg =? AND events.delete_flg =? ",current_user.id, false, false).select("events.*,count(admin_event_participants.admin_event_id) as join_count").group(:id).order(updated_at: :desc).limit(4)

    # partner_news list for dashboard
    @partner_news_list = Student::Student.new.get_partner_news_list(4).limit(4)
  end

  #student scouted result list
  def student_scouted_result
    # set previous path for breadcrumbs
    cookies[:previous_url] = '/student/scouted_result'
    scouted_status_query = ""
    scouted_status_query = params[:scout_status].blank? ? params[:scout_status] = [] : "communications.scout_status = #{params[:scout_status]}" 
    @student_scouted_result =  Student::Student.new.get_student_scouted_result(current_user.student.id,[scouted_status_query]) 
    @student_scouted_result = Kaminari.paginate_array(@student_scouted_result).page(params[:page]).per(12)
    render "communication/communications/list/student_scouted_result_list"
  end    

  # view all favourite company list
  def favourite_company_index
    @all_favourite_company_list = Student::Student.new.get_favourite_company_list(current_user.student.id)
    @all_favourite_company_list = Kaminari.paginate_array(@all_favourite_company_list).page(params[:page]).per(12)
    render 'student/students/list/favourite_company_index'
  end

  # view all applied vacancy list
  def applied_vacancy_index
    # set previous path for breadcrumbs
    cookies[:previous_url] = "/student/applied_vacancy_index"    
    @all_applied_vacancy_list = Company::Vacancy.select("company_vacancies.*, vacancy_apply_favourites.favourite_flg, vacancy_apply_favourites.apply_flg")
                                .joins(:vacancy_apply_favourites)
                                .where("student_id = #{current_user.student.id} and apply_flg = true")
    @all_applied_vacancy_list = Kaminari.paginate_array(@all_applied_vacancy_list).page(params[:page]).per(12)
    render 'student/students/list/applied_vacancy_index'
  end

  # view all favourite vacancy list
  def favourite_vacancy_index
    # set previous path for breadcrumbs
    cookies[:previous_url] = "/student/favourite_vacancy_index"
    @all_favourite_vacancy_list = Student::Student.new.get_favourite_vacancy_list(current_user.student.id)
    @all_favourite_vacancy_list = Kaminari.paginate_array(@all_favourite_vacancy_list).page(params[:page]).per(12)
    render 'student/students/list/favourite_vacancy_index'
  end

  # view all published entry event list
  def join_event_index
    # set previous path for breadcrumbs
    cookies[:previous_url] = "/student/join_event_index"
    join_company_event_list = Student::Student.new.get_join_company_event_list(current_user.student.id)
    join_admin_event_list = Student::Student.new.get_join_admin_event_lists(current_user.id)
    join_event_lists = join_company_event_list + join_admin_event_list
    join_event_list = join_event_lists.sort_by(&:event_start_date).reverse
    @all_join_event_list = Kaminari.paginate_array(join_event_list).page(params[:page]).per(12)
    render 'student/students/list/join_event_index'
  end

  # view all favourite event list
  def favourite_event_index
    # set previous path for breadcrumbs
    cookies[:previous_url] = "/student/favourite_event_index"
    @all_favourite_event_list = Student::Student.new.get_favourite_event_list(current_user.student.id)
    @all_favourite_event_list = Kaminari.paginate_array(@all_favourite_event_list).page(params[:page]).per(12)
    render 'student/students/list/favourite_event_index'
  end

  # view all joined admin event list
  def joined_admin_event_index
    # set previous path for breadcrumbs
    cookies[:previous_url] = "/student/joined_admin_event_index"
    
    #joined admin event list for dashboard
    @all_join_event_list =  Admin::Event.joins(:admin_event_participants).where("admin_event_participants.user_id =? AND admin_event_participants.delete_flg =? AND events.delete_flg =? ",current_user.id, false, false).select("events.*,count(admin_event_participants.admin_event_id) as join_count").group(:id).order(updated_at: :desc).limit(4)
    @all_join_event_list = Kaminari.paginate_array(@all_join_event_list).page(params[:page]).per(12)
    render 'student/students/list/joined_admin_event_index'
  end

  # GET /student/students/1 or /student/students/1.json
  def show
    @favourite_company_count = Student::Student.new.get_favourite_company_list(current_user.student.id).length
    @join_event_count = Student::Student.new.get_join_event_list(current_user.student.id).length
    @favourite_event_count = Student::Student.new.get_favourite_event_list(current_user.student.id).length
  end

  # GET /student/students/new
  def new
    @student_student = Student::Student.new
  end

  # GET /student/students/1/edit
  def edit
    @genuine_password_flag = false || params[:genuine_password]
  end

  # POST /student/students or /student/students.json
  def create
    @student_student = Student::Student.new(student_student_params)
    # convert json data type to array
    graduation_date = Date.strptime(params[:student_student][:graduation_date], '%Y年%m月')
    @student_student.graduation_date = graduation_date.strftime('%Y-%m')
    outside_activity = getJsonKey(params[:student_student][:outside_school_activity])
    @student_student.outside_school_activity = outside_activity
    respond_to do |format|
      if @student_student.save
        format.html { redirect_to @student_student }
        format.json { render :show, status: :created, location: @student_student }
      else
        format.html { render :new }
        format.json { render json: @student_student.errors, status: :unprocessable_entity }
      end
    end
  end
 

  # PATCH/PUT /student/students/1 or /student/students/1.json
  def update    
    # convert json data type to array
    outside_activity = getJsonKey(params[:student_student][:outside_school_activity])
    @user_student.outside_school_activity = outside_activity
    respond_to do |format|
      # To delete upload image
      @user_student.image.purge if params[:student_student][:imageFlag] == 'true'
      # To delete upload pdf file
      @user_student.attachment_for_pr.purge if params[:student_student][:haveFileFlag] == 'true'     
      if @user_student.update(student_student_params)
        unless params[:student_student][:image_data].eql? 'false'
          blob = convert_Base64_imgData(params[:student_student][:image_data])
          @user_student.image.attach(blob)
          params[:student_student][:image_data] = false
        end
        format.html { redirect_to edit_student_student_url }
        format.json { render :show, status: :ok, location: @user_student }
        flash[:success] = [t('common.update_success'), t('common.registration_confirm_screen')]
      else
        format.html { render :edit }
        format.json { render json: @user_student.errors, status: :unprocessable_entity }
        flash[:error] = [t('common.update_error'), t('common.registration_confirm_screen')]
      end
    end  
  end

  # DELETE /student/students/1 or /student/students/1.json
  def destroy
    @student_student.destroy
    respond_to do |format|
      format.html { redirect_to student_students_url }
      format.json { head :no_content }
    end
  end

  def profile_detail
    set_user_student
  end

  def new_profile_edit
    set_user_student
  end

  def user_confirm_member
    @company_company_members = Company::CompanyMember.select('company_members.*,company_roles.role_type,companies.company_name').left_outer_joins(:company_roles).joins("LEFT JOIN companies on companies.id = company_members.company_id").where("company_members.user_id = '#{params[:id]}'AND company_members.join_flag = false ")
    render 'student/students/list/student_join_member_index'
  end

  # Get all partner news list
  def partner_news_index
    cookies[:previous_url] = "/partner_news_index"
    @all_partner_news_list = Student::Student.new.get_partner_news_list(4)
    @all_partner_news_list = Kaminari.paginate_array(@all_partner_news_list).page(params[:page]).per(12)
    render 'student/students/list/partner_news_index'
  end

  # Get partner news detail
  def partner_news_detail
    @partner_news = Student::Student.new.get_partner_news(params[:id])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_student_student
    @student_student = Student::Student.find(params[:id])
  end

  def set_user_student
    @user_student = current_user.student
  end

  # Only allow a list of trusted parameters through.
  def student_student_params
    # params.fetch(:student_student, {})
    params.require(:student_student).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :gender,
                                            :image, :birthday, :nick_name, :email, :email_two, :address, :postal_code, :display_address, :phone_no, :postal_region_id, :region_name, :postal_prefecture_id, :prefecture_name, :postalcode_city, :school_type, :school_name, :department_name, :subject_system, :graduation_date, :m_region_id, :club_name, :club_position, :club_detail_activity, :club_guide, :is_beelab_activity_participate, :beelab_college_achievements, :attachment_for_pr, :sns_blog_for_pr, :pando_info, :job_info, :progress_complete, :not_step_form, qualification_category_id: [], qualification_type_id: [], desire_job_type_id: [], desire_industry_type_id: [], m_prefecture_id: [], outside_school_activity: [],  progress_details: [:id, :type, :percent])
  end
end