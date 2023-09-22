class Kodawarione::PartnerManage::PartnerStepsController < ApplicationController
    before_action :authenticate_admin!
    layout 'layouts/template/kodawarione'
    before_action :set_partner, only: %i[show update]
    include Wicked::Wizard
    authorize_resource class: 'Kodawarione::PartnerStep'
    steps :partner_setup, :partner_member_setup, :complete
  
    def new
      @partner = Kodawarione::Partner.new
    end
    
    def create
      @partner = Kodawarione::Partner.new(partner_create_params)
      count = Kodawarione::Partner.count
      count += 1
      @partner.partner_code = count.to_s.rjust(4, '0')
      @partner.super_partner_id = current_admin.admin_member.super_partners_id if current_admin.super_partner?
      if @partner.save
        session[:created_partner_id] = @partner.id
        redirect_to kodawarione_partner_manage_partner_steps_path
      else
        render :new
      end
    end
    
    def show
        render_wizard
    end
  
    def update
      case step
      when :partner_setup
        if @partner.update(partner_params(params[:id]))
          render_wizard @partner 
        else
          render_wizard @partner
        end
      when :partner_member_setup
        if @admin.id == nil
          @admin = Admin.new(admin_user_params)
          @admin.check_password = false
          if @admin.save
            @member = @partner.admin_members.build
            @member.admins_id = @admin.id
            @member.admin_roles_id = 3
            @member.update(partner_params(params[:id]))
          else
          end
        else
          @admin.check_password = false
          if @admin.update(admin_user_params)
            @member.update(partner_params(params[:id]))
          end
        end
        render_wizard @member
      end
    end
  
    private
  
    def set_partner
      if session[:created_partner_id] != nil 
        @partner = Kodawarione::Partner.find(session[:created_partner_id])
        if @partner.admin_members.present?
          @member = @partner.admin_members.map{|obj| obj}[0]
          @admin = Admin.find(@member.admins_id)
        else
          @admin = Admin.new
        end
      else
        redirect_to new_kodawarione_super_partner_manage_super_partner_step_path
      end
    end
  
    def partner_params(step)
       case step
        when "partner_setup"
          params.require(:kodawarione_partner).permit(:name,:partner_code,:postal_code, :address, :display_address, :phone_no, :website_url, :postalcode_city, :m_region_id, :region_name, :m_prefecture_id, :prefecture_name )
        when "partner_member_setup"
          params.permit(:admins_id, :admin_roles_id, :partners_id)
        end
    end
  
    def partner_create_params
      params.require(:kodawarione_partner).permit(:name, :super_partner_id)
    end

    def admin_user_params
      params.require(:admin).permit(:first_name,:last_name,:email, :password, :password_confirmation)
    end
    
  end
  