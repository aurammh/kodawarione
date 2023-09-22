class Kodawarione::SuperPartnerManage::SuperPartnersController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_super_partner, only: %i[ super_partner_member_list super_partner_details edit_super_partner_details update_super_partner_details ]
    before_action :set_super_partner_member, only: %i[ show_super_partner_member_setup edit_super_partner_member_setup update_super_partner_member_setup destroy_super_partner_member ]
    authorize_resource class: 'Kodawarione::SuperPartner'
    include CommonHelper
    layout 'layouts/template/kodawarione'

    def index
        keyword = params[:keyword].blank? ? nil : params[:keyword].strip
        startDate = params[:startDate].blank? ? nil : params[:startDate]
        endDate = params[:endDate].blank? ? nil : params[:endDate]
        if startDate.blank? && !endDate.blank?
        @admin_super_partners = Admin::SuperPartner.admin_su_partners_search_by_date_to(endDate, keyword)
        elsif(!startDate.blank? && endDate.blank?)
            @admin_super_partners = Admin::SuperPartner.admin_su_partners_search_by_date_from(startDate, keyword)
        elsif(!startDate.blank? && !endDate.blank?)
            @admin_super_partners = Admin::SuperPartner.admin_su_partners_search_by_date_between(startDate, endDate, keyword)   
        else
        @admin_super_partners = Admin::SuperPartner.admin_su_partners_all_list(keyword)
        end 
        @results = Kaminari.paginate_array(@admin_super_partners).page(params[:page]).per(12)
    end    

    # start super_partner_details
    def super_partner_details
        @super_partner_members = Kodawarione::AdminMember.joins(:admins).select("admins.*,admin_members.id as member_id,admin_members.super_partners_id").where(super_partners_id: @super_partner.id, admin_roles_id: 2, delete_flg: false).order("created_at desc")
        superPartnerIdParam = params[:id]      

        # Compnay and studnet count bar chart in Admin Super Parnter Dashaboard
        searchDate = params[:searchDate].blank? ? nil : params[:searchDate]
        start_date = searchDate.nil? || searchDate.empty?? Date.today.at_beginning_of_month : Date.new(searchDate.split('-')[0].to_i, searchDate.split('-')[1].delete_prefix("0").to_i)
        end_date = (start_date >> 1) - 1

        @studentCountListResult = []
        @companyCountListResult = []
        @dateArrayListForLabel = []

        # Total Student Count & Company Count
        @studentCountList = Student::Student.stu_find_by_spu_with_date(start_date,end_date,superPartnerIdParam)
        @companyCountList = Company::Company.com_find_by_spu_with_date(start_date,end_date,superPartnerIdParam) 
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

        # Student Gender Chart
        genderLabel = []
    
        # Student Gender Dognut Chart
        studentCountListByGender = Student::Student.new.get_student_count_for_super_partner_details(superPartnerIdParam)
        @studentCountListByGenderResult = studentCountListByGender.blank? ? [] : studentCountListByGender.map{|data| [data.count]}           
        @genderLabel = studentCountListByGender.blank? ? [] : studentCountListByGender.map{|data| t("student.gender.#{Student::Student.genders.key(data.gender_name)}")}  
        
        # Company Employee Donut Chart
        companyCountListByEmployeeCount = Company::Company.new.get_company_count_by_employee_count_for_super_partner_details(superPartnerIdParam)
        @companyCountByEmployeeCount = companyCountListByEmployeeCount.blank? ? []: companyCountListByEmployeeCount.map{|data| data.count}
        @companyEmployeeCountLabel = companyCountListByEmployeeCount.blank? ? []: companyCountListByEmployeeCount.map{|data| data.status}
    end

    def edit_super_partner_details
    end

    def update_super_partner_details
        respond_to do |format|
          if @super_partner.update(super_partner_details_params)
            format.html { redirect_to kodawarione_super_partner_manage_super_partner_details_path(@super_partner) }
          else
            format.html { render :edit_super_partner_details }
            format.json { render json: @super_partner.errors, status: :unprocessable_entity }
          end
        end
    end
    # end super_partner_details

    # start super_partner_member_setup
    def super_partner_member_list
      @super_partner_members = Kodawarione::AdminMember.joins(:admins).select("admins.*,admin_members.id as member_id,admin_members.super_partners_id").where(super_partners_id: @super_partner.id, delete_flg: false).order("created_at desc")
      @super_partner_members = Kaminari.paginate_array(@super_partner_members).page(params[:page]).per(12)
    end
    
    def new_super_partner_member_setup
      @admin = Admin.new
    end

    def create_super_partner_member_setup
      @admin = Admin.new(super_partner_member_setup_params)
      @admin.check_password = false
      respond_to do |format|
        if @admin.save
          @member = Kodawarione::AdminMember.new
          @member.admins_id = @admin.id
          @member.admin_roles_id = 2
          @member.super_partners_id = params[:id]
          @member.save
          format.html { redirect_to kodawarione_super_partner_manage_super_partner_details_path(@member.super_partners_id) }
        else
          format.html { render :new_super_partner_member_setup, status: :unprocessable_entity }
          format.json { render json: @admin.errors, status: :unprocessable_entity }
        end
      end
    end

    def show_super_partner_member_setup
    end

    def edit_super_partner_member_setup
    end

    def update_super_partner_member_setup
      respond_to do |format|   
        if @admin.update(super_partner_member_setup_params)  
          format.html { redirect_to kodawarione_super_partner_manage_super_partner_details_path(@member.super_partners_id)}        
          format.json { head :no_content } 
        else    
          format.html { render "kodawarione/super_partner_manage/super_partners/edit_super_partner_member_setup" }
          format.json { render json: @admin.errors, status: :unprocessable_entity }
        end           
      end 
    end

    def destroy_super_partner_member
      @member.update_columns(delete_flg: true)
      redirect_to kodawarione_super_partner_manage_super_partner_details_path(@member.super_partners_id)
    end
    # end super_partner_member_setup 

    private

    def set_super_partner
      @super_partner = Kodawarione::SuperPartner.find(params[:id])
    end

    def set_super_partner_member
      @member = Kodawarione::AdminMember.find(params[:id])
      @admin = Admin.find(@member.admins_id)
    end

    def super_partner_details_params
        params.require(:kodawarione_super_partner).permit(:name, :super_partner_code, :postal_code, :address, :display_address, :phone_no, :website_url, :postalcode_city, :m_region_id, :region_name, :m_prefecture_id, :prefecture_name)
    end
    
    def super_partner_member_setup_params
        params.require(:admin).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
end