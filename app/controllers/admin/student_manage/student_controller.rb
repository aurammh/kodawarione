class Admin::StudentManage::StudentController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_student, only: %i[ student_edit student_update  student_details student_delete]
  include Student::AssessmentsHelper
  include CommonHelper
  layout 'layouts/template/admin'

  def student_search
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    startDate = params[:startDate].blank? ? nil : params[:startDate]
    endDate = params[:endDate].blank? ? nil : params[:endDate]
    graStartYearMonth = params[:startDate].blank? ? nil : params[:startDate].partition('-').first + "-" + params[:startDate].partition('-').last.partition('-').first
    graEndYearMonth =  params[:endDate].blank? ? nil : params[:endDate].partition('-').first + "-" + params[:endDate].partition('-').last.partition('-').first
    date_type = params[:date_type]
    gender_keyword = params[:gender_keyword].blank? ? nil : Student::Student.genders["#{params[:gender_keyword]}"]
    schooltype_keyword = params[:school_type].blank? ? nil : Student::Student.school_types["#{params[:school_type]}"]
            
    if (startDate.blank? && !endDate.blank?)
        @results_list = Student::Student.admin_search_by_only_end_date(date_type,endDate,keyword,gender_keyword,schooltype_keyword)
  
    elsif(!startDate.blank? && endDate.blank?)
      @results_list = Student::Student.admin_search_by_only_start_date(date_type,startDate,keyword,gender_keyword,schooltype_keyword)

    elsif(!startDate.blank? && !endDate.blank?)
      @results_list = Student::Student.admin_search_by_between_two_date(date_type,startDate,endDate,keyword,gender_keyword,schooltype_keyword)

    else
      @results_list = Student::Student.admin_all_init_list(keyword,gender_keyword,schooltype_keyword)
    end   
    @assessment = @results_list.empty? ? [] : Student::Assessment.where("student_id IN (#{@results_list.map{ |data| data.id }.join(',')})").map{ |data| data.student_id }
    @results = Kaminari.paginate_array(@results_list).page(params[:page]).per(12)

    # Only for Excel Download
    if request.format.xlsx?
      @qualification_category_type = MQualification.all.map{|data| [data.id , data.qualification_category]}.to_h
      @qualification_type = MQualificationDetail.all.map{|data| [data.id , data.qualification_type]}.to_h
      @desire_industry_type = MIndustry.all.map{|data| [data.id, data.industry_name]}.to_h
      @desire_job_type = MOccupation.all.map{|data| [data.id, data.occupation_name]}.to_h
      @prefecture_type = MPrefecture.all.map{ |data| [data.id, data.prefecture_name]}.to_h
      @region_type = MRegion.all.map{|data| [data.id, data.region_name]}.to_h
    end

    respond_to do |format|
      format.html
      format.xlsx { render xlsx: t('search.excel_file_student'), template: 'admin/excel_template/student_excel_export'}
    end
  end

  def student_edit
  end

  def student_update
    #convert json data type to array
    outside_activity = getJsonKey(params[:student_student][:outside_school_activity])
    @student_info.outside_school_activity = outside_activity
    respond_to do |format|
      #To delete upload image
        if (params[:student_student][:imageFlag] == "true")
          @student_info.image.purge
        end
      #To delete upload pdf file
        if (params[:student_student][:haveFileFlag] == "true")
          @student_info.attachment_for_pr.purge
        end
      if @student_info.update(admin_student_params)
        unless params[:student_student][:image_data].eql?"false"
          blob = convert_Base64_imgData(params[:student_student][:image_data])
          @student_info.image.attach(blob)
          params[:student_student][:image_data] = false
        end
        format.html { redirect_to admin_student_manage_student_details_path(id: @student_info.id, status: params[:status])}
        format.json { render :show, status: :ok, location: @student_info }
      else
        format.html { render :student_edit }
        format.json { render json: @student_info.errors, status: :unprocessable_entity }
      end
    end
  end

  def student_details
    @student_assessment = @student_info.assessment
    #For chart One
    selfEevaluationChart_rank(@student_assessment)
    #For chart Two
    potentialDesireType(@student_assessment)
    #For chart Three
    behavioralTraitTypeChart_rank(@student_assessment)
  end

  def student_delete
    @student_info.update_columns(delete_flg: true)
    @student_info.user.update_columns(delete_flg: true, email: @student_info.user.email+"_"+@student_info.user.id.to_s)
    if params[:status] == "1"
      redirect_to admin_student_manage_student_search_path      	 
    else
      redirect_to admin_admin_student_setting_path
    end
  end

  def admin_student_setting
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    name = params[:student_name].blank? ? nil : params[:student_name].strip
    @permission_type = Admin::MPermissionType.where(use_student: true, id: 1 )
    @permissions = Admin::Permission.where(user_type: 1)
    if name.nil?  && keyword.nil?
      @results = User.admin_student_setting_all()
    else
      @results = User.admin_student_search_setting(name, keyword)
    end  
    @results = Kaminari.paginate_array(@results).page(params[:page]).per(12)
  end

  def set_permission
    permission = Admin::Permission.find_by(admin_permission_type_id: params[:type_id], user_id: params[:user_id])
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
        permis_data.user_type = 1
        permis_data.ip_address = request.ip 
        permis_data.save!
      end
    end
  end

  def admin_favourite_student
    @favourite_student_list = Student::Student.new.show_top_3_fav_student()
  end

  private
  def set_admin_student
    @student_info = Student::Student.find(params[:id])
    @user = @student_info.user
  end

  # Only allow a list of trusted parameters through.
  def admin_student_params
    #params.fetch(:student_student, {})
    params.require(:student_student).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :gender, :image, :birthday, :nick_name, :email, :email_two, :address, :postal_code, :display_address, :phone_no, :postal_region_id, :region_name, :postal_prefecture_id, :prefecture_name, :postalcode_city, :school_type, :school_name, :department_name, :subject_system, :graduation_date, :m_region_id, :club_name, :club_position, :club_detail_activity, :club_guide, :is_beelab_activity_participate, :beelab_college_achievements, :attachment_for_pr, :sns_blog_for_pr, :pando_info,:job_info, qualification_category_id: [], qualification_type_id: [], desire_job_type_id: [], desire_industry_type_id: [], m_prefecture_id: [], :outside_school_activity => [])
  end  
end