class Admin::SuperPartnersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_super_partner, only: %i[ show edit update destroy ]
  include CommonHelper
  layout 'layouts/template/admin'

  # GET /admin/super_partners or /admin/super_partners.json
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

  # GET /admin/super_partners/1 or /admin/super_partners/1.json
  def show
  end

  # GET /admin/super_partners/new
  def new
    @admin_super_partner = Admin::SuperPartner.new
  end

  # GET /admin/super_partners/1/edit
  def edit
  end

  # POST /admin/super_partners or /admin/super_partners.json
  def create
    @admin_super_partner = Admin::SuperPartner.new(admin_super_partner_params)
    count = Admin::SuperPartner.count
    count += 1
    @admin_super_partner.super_partner_code = count.to_s.rjust(4, '0')

    respond_to do |format|
      if @admin_super_partner.save
        format.html { redirect_to @admin_super_partner, notice: "Super partner was successfully created." }
        format.json { render :show, status: :created, location: @admin_super_partner }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_super_partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/super_partners/1 or /admin/super_partners/1.json
  def update
    respond_to do |format|
      if @admin_super_partner.update(admin_super_partner_params)
        format.html { redirect_to admin_super_partners_path(:id => @admin_super_partner.id), notice: "Partner was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_super_partner }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_super_partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/super_partners/1 or /admin/super_partners/1.json
  def destroy
    @admin_super_partner.update_columns(delete_flg: true)
    redirect_to admin_super_partners_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_super_partner
      @admin_super_partner = Admin::SuperPartner.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_super_partner_params
      # params.fetch(:admin_super_partner, {})
      params.require(:admin_super_partner).permit(:name,:super_partner_code,:postal_code,
      :address, :display_address, :phone_no, :website_url, :postalcode_city, :m_region_id, :region_name, :m_prefecture_id, :prefecture_name )
    end
end
