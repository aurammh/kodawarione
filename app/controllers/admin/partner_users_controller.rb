class Admin::PartnerUsersController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_admin_partner_user, only: %i[ show edit update destroy ]
    include CommonHelper
    layout 'layouts/template/admin'
   
    # GET /admin/partner_users or /admin/partner_users.json
    def index
      @partner_id = params[:partner_id].blank? ? nil : params[:partner_id]

      keyword = params[:keyword].blank? ? nil : params[:keyword].strip
      startDate = params[:startDate].blank? ? nil : params[:startDate]
      endDate = params[:endDate].blank? ? nil : params[:endDate]
      if startDate.blank? && !endDate.blank?
        @partner_users = PartnerUser.admin_partners_users_search_by_date_to(endDate, keyword,@partner_id)
      elsif(!startDate.blank? && endDate.blank?)
          @partner_users = PartnerUser.admin_partners_users_search_by_date_from(startDate, keyword,@partner_id)
      elsif(!startDate.blank? && !endDate.blank?)
          @partner_users = PartnerUser.admin_partners_users_search_by_date_between(startDate, endDate, keyword,@partner_id)   
      else
        @partner_users = PartnerUser.admin_partners_users_all_list(keyword,@partner_id)
      end 
      #@partner_users = PartnerUser.where(partner_id: @partner_id,delete_flg: false)
      @admin_partner_users = Kaminari.paginate_array(@partner_users).page(params[:page]).per(12)
    end
  
    # GET /admin/partner_users/1 or /admin/partner_users/1.json
    def show
    end
  
    # GET /admin/partner_users/new
    def new
      @partner_id = params[:partner_id]
      @admin_partner_user = PartnerUser.new
    end
  
    # GET /admin/partner_users/1/edit
    def edit
    end
  
    # POST /admin/partner_users or /admin/partner_users.json
    def create
      @partner_id = params[:partner_user][:partner_id]
      @admin_partner_user = PartnerUser.new(admin_partner_user_params)
      @admin_partner_user.check_password = true
      @admin_partner_user.partner_id = params[:partner_user][:partner_id]
  
  
      respond_to do |format|
        if @admin_partner_user.save
          format.html { redirect_to admin_partner_users_path(partner_id:params[:partner_user][:partner_id]), notice: "Partner user was successfully created." }
          format.json { render :show, status: :created, location: @admin_partner_user }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @admin_partner_user.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /admin/partner_users/1 or /admin/partner_users/1.json
    def update
      respond_to do |format|
        @admin_partner_user.skip_reconfirmation!
        if @admin_partner_user.update(admin_partner_user_params)
          format.html { redirect_to admin_partner_users_path(partner_id:@admin_partner_user.partner_id), notice: "Partner user was successfully updated." }
          format.json { render :show, status: :ok, location: @admin_partner_user }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @admin_partner_user.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /admin/partner_users/1 or /admin/partner_users/1.json
    def destroy
      #@admin_partner_user.destroy
      @admin_partner_user.update_columns(delete_flg: true)
      respond_to do |format|
        format.html { redirect_to admin_partner_users_path(partner_id:@admin_partner_user.partner_id), notice: "Partner user was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_admin_partner_user
        @admin_partner_user = PartnerUser.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def admin_partner_user_params
        #params.fetch(:admin_partner_user, {})
        params.require(:partner_user).permit(:first_name,:last_name,:email,
        :password,:password_confirmation )
      end
  end