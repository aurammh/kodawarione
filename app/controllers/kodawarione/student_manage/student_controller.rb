class Kodawarione::StudentManage::StudentController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_student, only: %i[ edit_commitment update_commitment edit_student_detail update_student_detail student_details overview assessment apply_vacancy_list favourite_vacancy_list favourite_company_list favourite_event_list join_event_list]
  before_action :get_fav_apply_count, only: %i[ apply_vacancy_list join_event_list favourite_vacancy_list favourite_company_list favourite_event_list edit_commitment update_commitment edit_student_detail update_student_detail student_details overview assessment]
  authorize_resource class: 'Kodawarione::StudentManage'
  include Student::AssessmentsHelper
  include CommonHelper
  layout 'layouts/template/kodawarione'
  
  # GET /kodawarione/student_manage/search_student
  def search_student  
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    startDate = params[:startDate].blank? ? nil : params[:startDate]
    endDate = params[:endDate].blank? ? nil : params[:endDate]
    graStartYearMonth = params[:startDate].blank? ? nil : params[:startDate].partition('-').first + "-" + params[:startDate].partition('-').last.partition('-').first
    graEndYearMonth =  params[:endDate].blank? ? nil : params[:endDate].partition('-').first + "-" + params[:endDate].partition('-').last.partition('-').first
    date_type = params[:date_type]
    gender_keyword = params[:gender_keyword].blank? ? nil : Student::Student.genders["#{params[:gender_keyword]}"]
    schooltype_keyword = params[:school_type].blank? ? nil : Student::Student.school_types["#{params[:school_type]}"]
            
    if (startDate.blank? && !endDate.blank?)
      @results_list = Student::Student.admin_search_by_only_end_date(date_type,endDate,keyword,gender_keyword,schooltype_keyword).where(query_with_current_role("users", "student_search"))
    elsif(!startDate.blank? && endDate.blank?)
      @results_list = Student::Student.admin_search_by_only_start_date(date_type,startDate,keyword,gender_keyword,schooltype_keyword).where(query_with_current_role("users", "student_search"))
    elsif(!startDate.blank? && !endDate.blank?)
      @results_list = Student::Student.admin_search_by_between_two_date(date_type,startDate,endDate,keyword,gender_keyword,schooltype_keyword).where(query_with_current_role("users", "student_search"))
    else
      @results_list = Student::Student.admin_all_init_list(keyword,gender_keyword,schooltype_keyword).where(query_with_current_role("users", "student_search"))
    end   
    @assessment = @results_list.empty? ? [] : Student::Assessment.where("student_id IN (#{@results_list.map{ |data| data.id }.join(',')})").map{ |data| data.student_id }
    @results = Kaminari.paginate_array(@results_list).page(params[:page]).per(12)     
  end      
  
  # GET /kodawarione/student_manage/edit/:id
  def edit_commitment
  end

  # POST /kodawarione/student_manage/commitment/update/:id
  def update_commitment
    respond_to do |format|
      @student_info.cover_photo.purge if params[:student_student][:imageFlag] == 'true' || params[:student_student][:coverImgFlag] == 'false'
      if @student_info.update(student_commitment_params)
        unless params[:student_student][:image_data].blank?
          unless params[:student_student][:image_data].eql? 'false'
            blob = convert_Base64_imgData(params[:student_student][:image_data])
            @student_info.cover_photo.attach(blob)
            params[:student_student][:image_data] = false
          end
        end
        format.html { redirect_to kodawarione_student_manage_edit_student_commitment_path(id: @student_info.id, status: params[:status])}
        flash[:success] = [t('common.update_success'), t('student_commitment.title.student_commitment_title')]
      else          
        format.html { render :edit_commitment }
        flash[:error] = [t('common.update_error'), t('student_commitment.title.student_commitment_title')]
      end
    end      
  end

  # GET /kodawarione/student_manage/student_detail/edit/:id
  def edit_student_detail
  end

  # POST /kodawarione/student_manage/student_detail/update/:id
  def update_student_detail
    graduation_date = Date.strptime(params[:student_student][:graduation_date], '%Y年%m月')
    @student_info.graduation_date = graduation_date.strftime('%Y-%m')
    outside_activity = getJsonKey(params[:student_student][:outside_school_activity])
    @student_info.outside_school_activity = outside_activity
    respond_to do |format|
      # To delete upload image
      @student_info.image.purge if params[:student_student][:imageFlag] == 'true'
      # To delete upload pdf file
      @student_info.attachment_for_pr.purge if params[:student_student][:haveFileFlag] == 'true'     
      if @student_info.update(student_params)
        unless params[:student_student][:image_data].eql? 'false'
          blob = convert_Base64_imgData(params[:student_student][:image_data])
          @student_info.image.attach(blob)
          params[:student_student][:image_data] = false
        end
        format.html { redirect_to kodawarione_student_manage_edit_student_detail_path }
        flash[:success] = [t('common.update_success'), t('common.registration_confirm_screen')]
      else
        format.html { render :edit_student_detail }
        flash[:error] = [t('common.update_error'), t('common.registration_confirm_screen')]
      end
    end  
  end

  # GET /kodawarione/student_manage/search_student_details/:id
  def student_details
  end

  # GET /kodawarione/student_manage/overview/:id
  def overview      
  end
   
  # GET /kodawarione/student_manage/student/assessment/:id
  def assessment
    @student_assessment = Student::Assessment.find_by(student_id: params[:id])
    #call radar chart one function
    selfEevaluationChart_rank(@student_assessment)
    #call radar chart two function
    potentialDesireType(@student_assessment)
    #call third function
    behavioralTraitTypeChart_rank(@student_assessment)
    # For commitment chart
    commitment_ability_chart(@student_info.user_id)
    unless @ability_list === [" "," "," "]
        @chart_commitment_label1 = @chart_commitment_label[0]
        @chart_commitment_label2 = @chart_commitment_label[1]
        @chart_commitment_label3 = @chart_commitment_label[2]
        @ability_list1 = @ability_list[0].name
        @ability_list2 = @ability_list[1].name
        @ability_list3 = @ability_list[2].name
        @ability_comment1 = @ability_list[0].ability_reason
        @ability_comment2 = @ability_list[1].ability_reason
        @ability_comment3 = @ability_list[2].ability_reason
    end
    @commitment_ability_list = MCommitmentAbility.select(:id,:name).order(id: :asc)
    @commitment_ability_detail_results = Student::StudentCommitmentAbilityDetail.select("ability_value,ability_reason,m_commitment_abilities_id,m_commitment_abilities.name,student_commitment_abilities.updated_at")
        .joins("INNER JOIN m_commitment_abilities ON m_commitment_abilities.id = student_commitment_ability_details.m_commitment_abilities_id")
        .joins("INNER JOIN student_commitment_abilities on student_commitment_abilities.id = student_commitment_ability_details.student_commitment_ability_id")
        .where("student_commitment_ability_details.student_id = ? and student_commitment_abilities.status = 'active'", @student_info.user_id)        
  end

  # GET /kodawarione/student_manage/student/apply_vacancy_list/:id
  def apply_vacancy_list
    # set previous path for breadcrumbs
    @all_applied_vacancy_list = Company::Vacancy.select("company_vacancies.*, vacancy_apply_favourites.favourite_flg, vacancy_apply_favourites.apply_flg")
                                .joins(:vacancy_apply_favourites)
                                .where("student_id = #{@student_info.id} and apply_flg = true")
    @all_applied_vacancy_list = Kaminari.paginate_array(@all_applied_vacancy_list).page(params[:page]).per(12)
  end

  # GET /kodawarione/student_manage/student/favourite_vacancy_list/:id
  def favourite_vacancy_list
    @all_favourite_vacancy_list = Student::Student.new.get_favourite_vacancy_list(@student_info.id)
    @all_favourite_vacancy_list = Kaminari.paginate_array(@all_favourite_vacancy_list).page(params[:page]).per(12)
  end

  # GET /kodawarione/student_manage/student/favourite_company_list/:id
  def favourite_company_list
    @all_favourite_company_list = Student::Student.new.get_favourite_company_list(@student_info.id)
    @all_favourite_company_list = Kaminari.paginate_array(@all_favourite_company_list).page(params[:page]).per(12)
  end

  # view all published entry event list
  def join_event_list   
    join_company_event_list = Student::Student.new.get_join_company_event_list(@student_info.id)
    join_admin_event_list = Student::Student.new.get_join_admin_event_lists(@student_info.id)
    join_event_lists = join_company_event_list + join_admin_event_list
    @all_join_event_list = join_event_lists.sort_by(&:event_start_date).reverse
    @all_join_event_list = Kaminari.paginate_array(@all_join_event_list).page(params[:page]).per(12)
  end

  # view all favourite event list
  def favourite_event_list
    @all_favourite_event_list = Student::Student.new.get_favourite_event_list(@student_info.id)
    @all_favourite_event_list = Kaminari.paginate_array(@all_favourite_event_list).page(params[:page]).per(12)
  end

  private

    def set_student
      @student_info = Student::Student.find(params[:id])
      @user = @student_info.user
      if current_admin.super_partner?
        redirect_to(kodawarione_student_manage_search_student_path) unless  get_query_partner_list_with_super_partner_id.include?(@user.partner_id)
      elsif current_admin.partner?
        redirect_to(kodawarione_student_manage_search_student_path) unless  @user.partner_id == current_admin.admin_member.partners_id
      end
    end

    def get_fav_apply_count
      @favourite_company_list = Student::Student.new.get_favourite_company_list(@student_info.id)
      @favourite_event_list = Student::Student.new.get_favourite_event_list(@student_info.id)
      @favourite_vacancy = Student::Student.new.get_favourite_vacancy_list(@student_info.id)
      @apply_vacancies =  Company::Vacancy.select("company_vacancies.*,vacancy_apply_favourites.favourite_flg, vacancy_apply_favourites.apply_flg")
                          .joins(:vacancy_apply_favourites)
                          .where("student_id = #{params[:id]} and apply_flg = true")
      # event posted list for dashboard
      join_company_event_list = Student::Student.new.get_join_company_event_list(@student_info.id)
      join_admin_event_list = Student::Student.new.get_join_admin_event_lists(@student_info.id)
      join_event_lists = join_company_event_list + join_admin_event_list
      @join_event_count = join_event_lists
      @join_event_list = join_event_lists.sort_by(&:event_start_date).reverse.take(4)
    end
  
    # Only allow a list of trusted parameters through.
    def student_commitment_params
      params.require(:student_student).permit(:nick_name, :current_address, :commitment,:birthday,:gender,:qualification_string, :cover_color, :cover_photo, preferred_working_area: [])
    end  

    def student_params
      params.require(:student_student).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :gender,
                                            :image, :birthday, :nick_name, :email, :email_two, :address, :postal_code, :display_address, :phone_no, :postal_region_id, :region_name, :postal_prefecture_id, :prefecture_name, :postalcode_city, :school_type, :school_name, :department_name, :subject_system, :m_region_id, :club_name, :club_position, :club_detail_activity, :club_guide, :is_beelab_activity_participate, :beelab_college_achievements, :attachment_for_pr, :sns_blog_for_pr, :pando_info, :job_info, :progress_complete, :not_step_form, qualification_category_id: [], qualification_type_id: [], desire_job_type_id: [], desire_industry_type_id: [], m_prefecture_id: [], outside_school_activity: [],  progress_details: [:id, :type, :percent])
    end  
end