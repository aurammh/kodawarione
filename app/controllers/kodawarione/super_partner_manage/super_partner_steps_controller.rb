class Kodawarione::SuperPartnerManage::SuperPartnerStepsController < ApplicationController
    before_action :authenticate_admin!
    layout 'layouts/template/kodawarione'
    before_action :set_super_partner, only: %i[show update]
    include Wicked::Wizard
    authorize_resource class: 'Kodawarione::SuperPartnerStep'
    steps :super_partner_setup, :super_partner_member_setup, :complete
  
    def new
      @super_partner = Kodawarione::SuperPartner.new
    end
    
    def create
      @super_partner = Kodawarione::SuperPartner.new(super_partner_create_params)
      count = Kodawarione::SuperPartner.count
      count += 1
      @super_partner.super_partner_code = count.to_s.rjust(4, '0')
      if @super_partner.save
        session[:created_super_partner_id] = @super_partner.id
        redirect_to kodawarione_super_partner_manage_super_partner_steps_path
      else
        render :new
      end
    end
    
    def show
        render_wizard
    end
  
    def update
      case step
      when :super_partner_setup
        if @super_partner.update(super_partner_params(params[:id]))
          render_wizard @super_partner 
        else
          render_wizard @super_partner
        end
      when :super_partner_member_setup
        if @admin.id == nil
          @admin = Admin.new(admin_user_params)
          @admin.check_password = false
          if @admin.save
            @member = @super_partner.admin_members.build
            @member.admins_id = @admin.id
            @member.admin_roles_id = 2
            @member.update(super_partner_params(params[:id]))
          else
          end
        else
          @admin.check_password = false
          if @admin.update(admin_user_params)
            @member.update(super_partner_params(params[:id]))
          end
        end
        render_wizard @member
      end
    end
  
    private
  
    def set_super_partner
      if session[:created_super_partner_id] != nil 
        @super_partner = Kodawarione::SuperPartner.find(session[:created_super_partner_id])
        if @super_partner.admin_members.present?
          @member = @super_partner.admin_members.map{|obj| obj}[0]
          @admin = Admin.find(@member.admins_id)
        else
          @admin = Admin.new
        end
      else
        redirect_to new_kodawarione_super_partner_manage_super_partner_step_path
      end
    end
  
    def super_partner_params(step)
       case step
        when "super_partner_setup"
          params.require(:kodawarione_super_partner).permit(:name,:super_partner_code,:postal_code, :address, :display_address, :phone_no, :website_url, :postalcode_city, :m_region_id, :region_name, :m_prefecture_id, :prefecture_name )
        when "super_partner_member_setup"
          params.permit(:admins_id, :admin_roles_id, :super_partners_id)
          
        end
    end
  
    def super_partner_create_params
      params.require(:kodawarione_super_partner).permit(:name)
    end

    def admin_user_params
      params.require(:admin).permit(:first_name,:last_name,:email, :password, :password_confirmation)
    end
    
  end
  