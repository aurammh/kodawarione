class Kodawarione::DashboardController < ApplicationController
    before_action :authenticate_admin!
    layout 'layouts/template/kodawarione'
    def index
        superPartnerIdParam = current_admin.admin_member.super_partners_id
        partner_id = current_admin.admin_member.partners_id
        searchDate = params[:searchDate].blank? ? nil : params[:searchDate]
        start_date = searchDate.nil? || searchDate.empty?? Date.today.at_beginning_of_month : Date.new(searchDate.split('-')[0].to_i, searchDate.split('-')[1].delete_prefix("0").to_i)
        end_date = (start_date >> 1) - 1

        @studentCountListResult = []
        @companyCountListResult = []
        @dateArrayListForLabel = []

        # Total Student Count & Company Count
        if current_admin.chief_administrator?
          @studentCountList = Student::Student.find_by_date(start_date,end_date)
        elsif current_admin.super_partner?
          @studentCountList = Student::Student.stu_find_by_spu_with_date(start_date,end_date,superPartnerIdParam)
        elsif current_admin.partner?
          studentCountList = Student::Student.find_by_date(start_date,end_date) 
          @studentCountList = studentCountList.joins(" LEFT JOIN users ON users.id = students.user_id ").where("users.partner_id = #{partner_id}")
        end

        if current_admin.chief_administrator?
          @companyCountList = Company::Company.find_by_date(start_date,end_date)   
        elsif current_admin.super_partner?
          @companyCountList = Company::Company.com_find_by_spu_with_date(start_date,end_date,superPartnerIdParam) 
        elsif current_admin.partner?
          companyCountList = Company::Company.find_by_date(start_date,end_date)
          @companyCountList = companyCountList.where(partner_id: partner_id)    
        end

        date_array = Hash.new
        (start_date).upto(end_date).each_with_index do |day,index|
          date_array[day.strftime('%Y-%m-%d')] = index
          @dateArrayListForLabel[index] = day.strftime('%-d日')
          @studentCountListResult[index] = 0
          @companyCountListResult[index] = 0     
        end

        @studentCountList.each do |data|
          @studentCountListResult[date_array[data.created_at.strftime('%Y-%m-%d')].to_i] = data[:studentcount]
        end
        @companyCountList.each do |data|
          @companyCountListResult[date_array[data.created_at.strftime('%Y-%m-%d')].to_i] = data[:companycount]
        end
        arr = [@studentCountListResult,@companyCountListResult]
        @maxValue = arr.map{|x| x.max}   
       
        # Student Gender Dognut Chart
        if current_admin.chief_administrator?
          studentCountListByGender = Student::Student.find_by_gender()
        elsif current_admin.super_partner?
          studentCountListByGender = Student::Student.find_by_gender_for_super_partner(superPartnerIdParam)
        elsif current_admin.partner?
          studentCountListByGender = Student::Student.find_by_gender_partner()
          studentCountListByGender = studentCountListByGender.where("users.partner_id = #{partner_id}")
        end
        @studentCountListByGenderResult = studentCountListByGender.blank? ? [] : studentCountListByGender.map{|data| [data.studentcount]}
        @genderLabel = studentCountListByGender.blank? ? [] : studentCountListByGender.map{|data| t("student.gender.#{Student::Student.genders.key(data.gender_name)}")}
 
        # Student Region bar Chart
        if current_admin.chief_administrator?
          studentCountListByRegion = Student::Student.new.get_student_count_by_region()
        elsif current_admin.super_partner?
          studentCountListByRegion = Student::Student.new.get_student_count_by_region_for_super_partner(superPartnerIdParam)
        elsif current_admin.partner?
          studentCountListByRegion = Student::Student.new.get_student_count_by_region()
          studentCountListByRegion = studentCountListByRegion.joins(" LEFT JOIN users ON users.id = students.user_id ").where("users.partner_id = #{partner_id}")
        end
        @studentResultCountByRegion = studentCountListByRegion.blank? ? []: studentCountListByRegion.map{|data| [data.count]} 
        @studentregionNameLabel = studentCountListByRegion.blank? ? []: studentCountListByRegion.map{|data| data.region}

        # Student SchoolType Dognut Chart
        if current_admin.chief_administrator?
          studentCountListBySchoolType = Student::Student.new.get_student_count_by_schooltype()
        elsif current_admin.super_partner?
          studentCountListBySchoolType = Student::Student.new.get_student_count_by_schooltype_for_super_partner(superPartnerIdParam)
        elsif current_admin.partner?
          studentCountListBySchoolType = Student::Student.new.get_student_count_by_schooltype()
          studentCountListBySchoolType =studentCountListBySchoolType.joins(" LEFT JOIN users ON users.id = students.user_id ").where("users.partner_id = #{partner_id}")
        end
        @studentCountListBySchoolTypeResult = studentCountListBySchoolType.blank? ? [] : studentCountListBySchoolType.map{|data| [data.count]}
        @schoolTypeLabel = studentCountListBySchoolType.blank? ? [] : studentCountListBySchoolType.map{|data| data.schooltype ==0? I18n.t('select.not_select') : t("student.school_type.#{Student::Student.school_types.key(data.schooltype)}")}    

        #News Noti from admin
        if current_admin.super_partner?
          @partner_news_list = Student::Student.new.get_partner_news_list(1).limit(4)
        elsif current_admin.partner?
          @partner_news_list = Student::Student.new.get_partner_news_list(2).limit(4)
        end

        # Company Region Dognut Chart
        if current_admin.chief_administrator?
          companyCountListByRegion = Company::Company.new.get_company_count_by_region()
        elsif current_admin.super_partner?
          companyCountListByRegion = Company::Company.new.get_company_count_by_region_for_super_partner(superPartnerIdParam)
        elsif current_admin.partner?
          companyCountListByRegion = Company::Company.new.get_company_count_by_region_for_partner(partner_id)
        end
        @companyResultCountByRegion = companyCountListByRegion.blank? ? []: companyCountListByRegion.map{|data| data.count}
        @companyRegionNameLabel = companyCountListByRegion.blank? ? []: companyCountListByRegion.map{|data| data.prefecture}
    
        # Company Employee Count Donut Chart
        if current_admin.chief_administrator?
          companyCountListByEmployeeCount = Company::Company.new.get_company_count_by_employee_count_for_dashboard()
        elsif current_admin.super_partner?
          companyCountListByEmployeeCount = Company::Company.new.get_company_count_by_employee_count_for_super_partner_dashboard(superPartnerIdParam)
        elsif current_admin.partner?
          companyCountListByEmployeeCount = Company::Company.new.get_company_count_by_employee_count_for_partner_dashboard(partner_id)
        end
        @companyCountByEmployeeCount = companyCountListByEmployeeCount.blank? ? []: companyCountListByEmployeeCount.map{|data| data.count}
        @companyEmployeeCountLabel = companyCountListByEmployeeCount.blank? ? []: companyCountListByEmployeeCount.map{|data| data.status} 
    end    
    # Get all partner news list
  def news_noti_index
    cookies[:previous_url] = "/news_noti_index"
    @all_partner_news_list = Student::Student.new.get_partner_news_list(4)
    @all_partner_news_list = Kaminari.paginate_array(@all_partner_news_list).page(params[:page]).per(12)
    render 'kodawarione/dashboard/news_noti_index'
  end

  # Get partner news detail
  def news_noti_detail
    @partner_news = Student::Student.new.get_partner_news(params[:id])
  end
end