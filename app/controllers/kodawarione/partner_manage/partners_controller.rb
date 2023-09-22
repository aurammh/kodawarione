class Kodawarione::PartnerManage::PartnersController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_partner_partner, only: %i[ partner_details partner_member_list edit_partner_details update_partner_details ]
    before_action :set_admin_member, only: %i[ edit_partner_member_setup update_partner_member_setup show_partner_member_setup destroy_partner_member]
    include CommonHelper
    layout 'layouts/template/kodawarione'
    
  
    # GET /admin/partners or /admin/partners.json
    def index
      keyword = params[:keyword].blank? ? nil : params[:keyword].strip
      startDate = params[:startDate].blank? ? nil : params[:startDate]
      endDate = params[:endDate].blank? ? nil : params[:endDate]
      if startDate.blank? && !endDate.blank?
        @partner_partners = Partner::Partner.admin_partners_search_by_date_to(endDate, keyword).where(query_with_current_role("partners", "partner_search"))
      elsif(!startDate.blank? && endDate.blank?)
        @partner_partners = Partner::Partner.admin_partners_search_by_date_from(startDate, keyword).where(query_with_current_role("partners", "partner_search"))
      elsif(!startDate.blank? && !endDate.blank?)
        @partner_partners = Partner::Partner.admin_partners_search_by_date_between(startDate, endDate, keyword).where(query_with_current_role("partners", "partner_search"))   
      else
        @partner_partners = Partner::Partner.admin_partners_all_list(keyword).where(query_with_current_role("partners", "partner_search"))
      end 
      @results = Kaminari.paginate_array(@partner_partners).page(params[:page]).per(12)
    end

    # start super_partner_details
    def partner_details
      @partner_members = Kodawarione::AdminMember.joins(:admins).select("admins.*,admin_members.id as member_id,admin_members.partners_id").where(partners_id: @partner.id, delete_flg: false).order("created_at desc")
      
      partner_id = params[:id]      

        # Compnay and studnet count bar chart in Admin Super Parnter Dashaboard
        searchDate = params[:searchDate].blank? ? nil : params[:searchDate]
        start_date = searchDate.nil? || searchDate.empty?? Date.today.at_beginning_of_month : Date.new(searchDate.split('-')[0].to_i, searchDate.split('-')[1].delete_prefix("0").to_i)
        end_date = (start_date >> 1) - 1

        @studentCountListResult = []
        @companyCountListResult = []
        @dateArrayListForLabel = []

        # Total Student Count & Company Count
        studentCountList = Student::Student.find_by_date(start_date,end_date) 
        @studentCountList = studentCountList.joins(" LEFT JOIN users ON users.id = students.user_id ").where("users.partner_id = #{partner_id}")

        companyCountList = Company::Company.find_by_date(start_date,end_date)
        @companyCountList = companyCountList.where(partner_id: partner_id) 

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
      studentCountListByGender = Student::Student.new.get_student_count_for_partner_details(partner_id)
      @studentCountListByGenderResult = studentCountListByGender.blank? ? [] : studentCountListByGender.map{|data| [data.count]}
      @genderLabel = studentCountListByGender.blank? ? [] : studentCountListByGender.map{|data| t("student.gender.#{Student::Student.genders.key(data.gender_name)}")}

      # Company Employee Count Donut Chart
      companyCountListByEmployeeCount = Company::Company.new.get_company_count_by_employee_count_for_partner_details(partner_id)
      @companyCountByEmployeeCount = companyCountListByEmployeeCount.blank? ? []: companyCountListByEmployeeCount.map{|data| data.count}
      @companyEmployeeCountLabel = companyCountListByEmployeeCount.blank? ? []: companyCountListByEmployeeCount.map{|data| data.status} 
    end

    def partner_member_list
      @partner_members = Kodawarione::AdminMember.joins(:admins).select("admins.*,admin_members.id as member_id,admin_members.partners_id").where(partners_id: @partner.id, delete_flg: false).order("created_at desc")
      @partner_members = Kaminari.paginate_array(@partner_members).page(params[:page]).per(12)
    end

    def edit_partner_details
    end

    def update_partner_details
      respond_to do |format|
        if @partner.update(partner_detail_params) 
          format.html { redirect_to kodawarione_partner_manage_partner_details_path(@partner)}
        else
          format.html { render :edit_partner_details }
          format.json { render json: @partner.errors, status: :unprocessable_entity }
        end
      end
    end
    
    def edit_partner_member_setup
    end

    def show_partner_member_setup
    end

    def update_partner_member_setup
        respond_to do |format|   
          if  @admin.update(partner_member_setup_params)    
              format.html { redirect_to kodawarione_partner_manage_partner_details_path(@member.partners_id)}        
          else    
            format.html { render "kodawarione/partner_manage/partners/edit_partner_member_setup" }
            format.json { render json: @admin.errors, status: :unprocessable_entity }
          end           
        end 
    end

    # start super_partner_member_setup 
    def new_partner_member_setup
      @admin = Admin.new
    end

    def create_partner_member_setup
      @admin = Admin.new(partner_member_setup_params)
      @admin.check_password = false
      respond_to do |format|
        if @admin.save
          @member = Kodawarione::AdminMember.new
          @member.admins_id = @admin.id
          @member.admin_roles_id = 3
          @member.partners_id = params[:id]
          @member.save
          format.html { redirect_to kodawarione_partner_manage_partner_details_path(@member.partners_id) }
        else
          format.html { render :new_partner_member_setup, status: :unprocessable_entity }
          format.json { render json: @admin.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy_partner_member
      @member.update_columns(delete_flg: true)
      redirect_to kodawarione_partner_manage_partner_details_path(@member.partners_id)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_partner_partner
        @partner = Kodawarione::Partner.find(params[:id])
      end
       
      def set_admin_member
        @member = Kodawarione::AdminMember.find(params[:id])
        @admin = Admin.find(@member.admins_id)
      end

      def partner_detail_params
        params.require(:kodawarione_partner).permit(:super_partner_id, :partner_code,:postal_code, :address, :display_address, :phone_no, :website_url, :postalcode_city, :m_region_id, :region_name, :m_prefecture_id, :prefecture_name)
      end

      def partner_member_setup_params
        params.require(:admin).permit(:first_name,:last_name,:email, :password, :password_confirmation, :current_password)
      end
end 