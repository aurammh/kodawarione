class Admin::PartnersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_partner_partner, only: %i[ show edit update destroy ]
  include CommonHelper
  layout 'layouts/template/admin'
  

  # GET /admin/partners or /admin/partners.json
  def index
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    startDate = params[:startDate].blank? ? nil : params[:startDate]
    endDate = params[:endDate].blank? ? nil : params[:endDate]
    if startDate.blank? && !endDate.blank?
      @partner_partners = Partner::Partner.admin_partners_search_by_date_to(endDate, keyword)
    elsif(!startDate.blank? && endDate.blank?)
        @partner_partners = Partner::Partner.admin_partners_search_by_date_from(startDate, keyword)
    elsif(!startDate.blank? && !endDate.blank?)
        @partner_partners = Partner::Partner.admin_partners_search_by_date_between(startDate, endDate, keyword)   
    else
      @partner_partners = Partner::Partner.admin_partners_all_list(keyword)
    end 
    @results = Kaminari.paginate_array(@partner_partners).page(params[:page]).per(12)
  end

  # GET /admin/partners/1 or /admin/partners/1.json
  def show
  end

  # GET /admin/partners/new
  def new
    @partner_partner = Partner::Partner.new
  end

  # GET /admin/partners/1/edit
  def edit
  end

  # POST /admin/partners or /admin/partners.json
  def create
    @partner_partner = Partner::Partner.new(partner_partner_params)
    count = Partner::Partner.count
    @partner_partner.partner_code = count.to_s.rjust(4, '0')

    respond_to do |format|
      if @partner_partner.save
        format.html { redirect_to admin_partners_path, notice: "Partner was successfully created." }
        format.json { render :show, status: :created, location: @partner_partner }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @partner_partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/partners/1 or /admin/partners/1.json
  def update
    respond_to do |format|
      if @partner_partner.update(partner_partner_params)
        format.html { redirect_to admin_partners_path(:id => @partner_partner.id), notice: "Partner was successfully updated." }
        format.json { render :show, status: :ok, location: @partner_partner }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @partner_partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/partners/1 or /admin/partners/1.json
  def destroy
    @partner_partner.update_columns(delete_flg: true)
    redirect_to admin_partners_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_partner_partner
      @partner_partner = Partner::Partner.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def partner_partner_params
      #params.fetch(:partner_partner, {})
      params.require(:partner_partner).permit(:name,:partner_code,:postal_code,
      :address, :display_address, :phone_no, :website_url, :postalcode_city, :m_region_id, :region_name, :m_prefecture_id, :prefecture_name )
    end
end
