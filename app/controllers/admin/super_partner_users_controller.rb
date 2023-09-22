class Admin::SuperPartnerUsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_su_partner_user, only: %i[ show edit update destroy ]
  include CommonHelper
  layout 'layouts/template/admin'
 
  # GET /admin/partner_users or /admin/partner_users.json
  def index
    @super_partner_id = params[:super_partner_id].blank? ? nil : params[:super_partner_id]
    @super_partner_users = SuperPartnerUser.where(super_partner_id: @super_partner_id, delete_flg: false)
    @admin_super_partner_users = Kaminari.paginate_array(@super_partner_users).page(params[:page]).per(12)
  end

  # GET /admin/partner_users/1 or /admin/partner_users/1.json
  def show
  end

  # GET /admin/partner_users/new
  def new
    @super_partner_id = params[:super_partner_id]
    @admin_super_partner_user = SuperPartnerUser.new
  end

  # GET /admin/partner_users/1/edit
  def edit
  end

  # POST /admin/partner_users or /admin/partner_users.json
  def create
    @super_partner_id = params[:super_partner_user][:super_partner_id]
    @admin_super_partner_user = SuperPartnerUser.new(admin_su_partner_user_params)
    @admin_super_partner_user.check_password = true
    @admin_super_partner_user.super_partner_id = params[:super_partner_user][:super_partner_id]

    respond_to do |format|
      if @admin_super_partner_user.save
        format.html { redirect_to admin_super_partner_users_path(super_partner_id: params[:super_partner_user][:super_partner_id]), notice: "Partner user was successfully created." }
        format.json { render :show, status: :created, location: @admin_super_partner_user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_super_partner_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/partner_users/1 or /admin/partner_users/1.json
  def update
    respond_to do |format|
      @admin_super_partner_user.skip_reconfirmation!
      if @admin_super_partner_user.update(admin_su_partner_user_params)
        format.html { redirect_to admin_super_partner_users_path(super_partner_id: @admin_super_partner_user.super_partner_id), notice: "Partner user was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_super_partner_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_super_partner_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/partner_users/1 or /admin/partner_users/1.json
  def destroy
    #@admin_partner_user.destroy
    @admin_super_partner_user.update_columns(delete_flg: true)
    respond_to do |format|
      format.html { redirect_to admin_super_partner_users_path(super_partner_id:@admin_super_partner_user.super_partner_id), notice: "Partner user was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_su_partner_user
      @admin_super_partner_user = SuperPartnerUser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_su_partner_user_params
      #params.fetch(:admin_partner_user, {})
      params.require(:super_partner_user).permit(:first_name, :last_name, :email, :password, :password_confirmation )
    end
end
