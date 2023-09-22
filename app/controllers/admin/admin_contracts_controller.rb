class Admin::AdminContractsController < ApplicationController
  before_action :set_admin_contract, only: %i[ show edit update destroy ]
  before_action :set_partner_name_list, only: %i[ create new edit update ]
  before_action :set_admin_plan_list, only: %i[ create new edit update ]
  include CommonHelper
  layout 'layouts/template/admin'
  # GET /admin/admin_contracts or /admin/admin_contracts.json
  def index
    @admin_contracts = Admin::AdminContract.all
    @results = Kaminari.paginate_array(@admin_contracts).page(params[:page]).per(12)
  end

  # GET /admin/admin_contracts/1 or /admin/admin_contracts/1.json
  def show
  end

  # GET /admin/admin_contracts/new
  def new
    @admin_contract = Admin::AdminContract.new
  end

  # GET /admin/admin_contracts/1/edit
  def edit
  end

  # POST /admin/admin_contracts or /admin/admin_contracts.json
  def create
    @admin_contract = Admin::AdminContract.new(admin_contract_params)
    @admin_contract.admin_id = current_admin.id
    respond_to do |format|
      if @admin_contract.save
        format.html { redirect_to admin_admin_contracts_path, notice: "Admin contract was successfully created." }
        format.json { render :show, status: :created, location: @admin_contract }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/admin_contracts/1 or /admin/admin_contracts/1.json
  def update
    respond_to do |format|
      if @admin_contract.update(admin_contract_params)
        format.html { redirect_to admin_admin_contracts_path, notice: "Admin contract was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_contract }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/admin_contracts/1 or /admin/admin_contracts/1.json
  def destroy
    @admin_contract.destroy
    respond_to do |format|
      format.html { redirect_to admin_admin_contracts_path, notice: "Admin contract was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_contract
      @admin_contract = Admin::AdminContract.find(params[:id])
    end

    def set_partner_name_list
      @partner_name_list =  Admin::SuperPartner.select(:id, :name).where(delete_flg: false)
    end

    def set_admin_plan_list
      @admin_plan_list =  Admin::AdminPlan.select(:id, :name)
    end

    # Only allow a list of trusted parameters through.
    def admin_contract_params
      # params.fetch(:admin_admin_contract, {})
      params.require(:admin_admin_contract).permit(:partner_id, :start_date, :end_date, :admin_plan_id, :payment_type, :training_start_date, :training_end_date)
    end
end
