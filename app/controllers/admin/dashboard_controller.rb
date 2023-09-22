class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  layout 'layouts/template/admin'
  include Student::StudentsHelper
  include Admin::DashboardHelper

  def index
    searchDate = params[:searchDate].blank? ? nil : params[:searchDate]
    start_date = searchDate.nil? || searchDate.empty?? Date.today.at_beginning_of_month : Date.new(searchDate.split('-')[0].to_i, searchDate.split('-')[1].delete_prefix("0").to_i)
    end_date = (start_date >> 1) - 1
    @year_month = searchDate.nil? || searchDate.empty?? Date.today.strftime('%Y-%m') : searchDate 

    student_info
    company_info 

    monthNum = params[:month_num] 
    @studentCountListResult = []
    @companyCountListResult = []
    @dateArrayListForLabel = []
    @genderLabel = []
    @studentCountListByGenderResult = []

    # Super partner all count
    @all_super_partner = Admin::SuperPartner.where(delete_flg: false)

    # Top 3 Favourite Company and all count
    @top3FavouriteCompany = Company::Company.new.show_top_3_fav_company().limit(3)
    @all_company = Company::Company.where(delete_flg: false)
    @company_list_by_vacancy_create = Company::Company.new.company_count_by_vacancy_create_by_admin()
    
    # Top 3 Favourite Student and all count
    @top3FavouriteStudent = Student::Student.new.show_top_3_fav_student().limit(3)
    @all_student = Student::Student.where(delete_flg: false)

    # Student Gender Dognut Chart
    studentCountListByGender = Student::Student.find_by_gender()
    @studentCountListByGenderResult = studentCountListByGender.blank? ? [] : studentCountListByGender.map{|data| [data.studentcount]}
    @genderLabel = studentCountListByGender.blank? ? [] : studentCountListByGender.map{|data| t("student.gender.#{Student::Student.genders.key(data.gender_name)}")}

    # Student Region Dognut Chart
    studentCountListByRegion = Student::Student.new.get_student_count_by_region()
    @studentResultCountByRegion = studentCountListByRegion.blank? ? []: studentCountListByRegion.map{|data| [data.count]} 
    @regionNameLabel = studentCountListByRegion.blank? ? []: studentCountListByRegion.map{|data| data.region}

    # Student SchoolType Dognut Chart
    studentCountListBySchoolType = Student::Student.new.get_student_count_by_schooltype()
    @studentCountListBySchoolTypeResult = studentCountListBySchoolType.blank? ? [] : studentCountListBySchoolType.map{|data| [data.count]}
    @schoolTypeLabel = studentCountListBySchoolType.blank? ? [] : studentCountListBySchoolType.map{|data| data.schooltype ==0? I18n.t('select.not_select') : t("student.school_type.#{Student::Student.school_types.key(data.schooltype)}")}    
    
    # Student STEAMS Info Dognut Chart
    studentCountListBySteamsInfo = Student::Student.new.get_student_count_by_steamsinfo()
    @studentCountListBySteamsInfoResult = studentCountListBySteamsInfo.blank? ? [] : studentCountListBySteamsInfo.map{|data| [data.std_count]}
    @steamsInfoLabel = studentCountListBySteamsInfo.blank? ? [] : studentCountListBySteamsInfo.map{|data| [data.isbeelabactivityparticipate]}

    # Company PostalCity Donut Chart
    companyCountListByPostalCity = Company::Company.new.get_company_count_by_postalcode_city()
    @companyResultCountByPostalCity = companyCountListByPostalCity.blank? ? []: companyCountListByPostalCity.map{|data| [data.count]}
    @postalNameLabel = companyCountListByPostalCity.blank? ? []: companyCountListByPostalCity.map{|data| data.city}

    # Company Region Dognut Chart
    companyCountListByRegion = Company::Company.new.get_company_count_by_region()
    @companyResultCountByRegion = companyCountListByRegion.blank? ? []: companyCountListByRegion.map{|data| [data.count]}
    @companyRegionNameLabel = companyCountListByRegion.blank? ? []: companyCountListByRegion.map{|data| data.prefecture}

    # Company Employee Count Donut Chart
    companyCountListByEmployeeCount = Company::Company.new.get_company_count_by_employee_count()
    @companyCountByEmployeeCount = companyCountListByEmployeeCount.blank? ? []: companyCountListByEmployeeCount.map{|data| data.count}
    @companyEmployeeCountLabel = companyCountListByEmployeeCount.blank? ? []: companyCountListByEmployeeCount.map{|data| data.status}

    # Company Plan Type Chart
    # companyCountListByPlanType = Partner::Contract.new.get_company_count_by_plan_type()
    # @companyCountByPlanTypeResult = companyCountListByPlanType.blank? ? []: companyCountListByPlanType.map{|data| data.count}
    # @planTypeLabelList = companyCountListByPlanType.blank? ? []: companyCountListByPlanType.map{|data| data.name}

    #company vacancy donut chart
    @companyCountByVacancy = Company::Vacancy.select(:company_id).distinct.count
    companyCountByCompanies = Company::Company.select(:id).count
    @companyCountByNoVacancy = companyCountByCompanies - @companyCountByVacancy

    #partner PostalCity Donut Chart
    partnerCountListByPostalCity = Partner::Partner.new.get_partner_count_by_postalcode_city()
    @partnerResultCountByPostalCity = partnerCountListByPostalCity.blank? ? []: partnerCountListByPostalCity.map{|data| [data.count]}
    @partnerPostalNameLabel = partnerCountListByPostalCity.blank? ? []: partnerCountListByPostalCity.map{|data| data.city}

     # Partner Region Donut Chart
     partnerCountListByRegion = Partner::Partner.new.get_partner_count_by_region()
     @partnerResultCountByRegion = partnerCountListByRegion.blank? ? []: partnerCountListByRegion.map{|data| [data.count]}
     @partnerRegionNameLabel = partnerCountListByRegion.blank? ? []: partnerCountListByRegion.map{|data| data.region}

     #Admin Plan Donut Chart
     partnerCountListByPlan = Admin::AdminContract.new.get_admin_count_by_plan()
     @partnerResultCountByPlan = partnerCountListByPlan.blank? ? []: partnerCountListByPlan.map{|data| [data.count]}
     @planNameLabel = partnerCountListByPlan.blank? ? []: partnerCountListByPlan.map{|data| data.plan_name}

    # Total Student Count & Company Count
    @studentCountList = Student::Student.find_by_date(start_date,end_date)
    @companyCountList = Company::Company.find_by_date(start_date,end_date)    

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
  end
  
  #For Admin Sing_IN
  def admin
    redirect_to(new_admin_session_path)
  end
end