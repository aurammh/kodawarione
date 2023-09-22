class Kodawarione::ContractsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_contract, only: %i[ show edit update destroy ]
  before_action :super_partner_list, only: %i[ create new edit update ]
  before_action :set_plan_list, only: %i[ create new edit update ]
  layout 'layouts/template/kodawarione'
  load_and_authorize_resource

  def index
    contracts = Kodawarione::Contract.where(delete_flg: false).where(query_with_current_role("contracts", "contracts_index"))
    @contracts = Kaminari.paginate_array(contracts).page(params[:page]).per(12)
  end

  def new
    @contract = Kodawarione::Contract.new
  end

  def create
    @contract = Kodawarione::Contract.new(contract_params)
    @contract.contract_from_id = current_admin.id
    @contract.contract_role_type = set_admin_role_type
    respond_to do |format|
      if @contract.save
        format.html { redirect_to kodawarione_contracts_path, notice: "Admin contract was successfully created." }
        format.json { render :show, status: :created, location: @contract }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @contract.update(contract_params)
        format.html { redirect_to kodawarione_contracts_path, notice: "Admin contract was successfully updated." }
        format.json { render :show, status: :ok, location: @contract }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contract.update_columns(delete_flg: true)
    respond_to do |format|
      format.html { redirect_to kodawarione_contracts_path, notice: "Admin contract was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_contract
    @contract = Kodawarione::Contract.find(params[:id])
  end

  def super_partner_list
    if current_admin.chief_administrator?
      @super_partner_list = Admin::SuperPartner.select(:id, :name).where(delete_flg: false)
    elsif current_admin.super_partner?
      @super_partner_list = Partner::Partner.select(:id, :name).where(query_with_current_role("partners", "partner_search"))
    elsif current_admin.partner?
      @super_partner_list = Company::Company.select(:id, :company_name).where(query_with_current_role("companies", "company_search"))
    end
  end

  def set_plan_list
    if current_admin.chief_administrator?
      @plan_list =  Kodawarione::Plan.select(:id, :name).where(delete_flg: false, plan_role_type: 1)
    elsif current_admin.super_partner?
      @plan_list = Kodawarione::Plan.select(:id, :name).where(delete_flg: false, plan_role_type: 2)
    elsif current_admin.partner?
      @plan_list = Kodawarione::Plan.select(:id, :name).where(delete_flg: false, plan_role_type: 3)
    end
  end

  def contract_params
    params.require(:kodawarione_contract).permit(:partner_id, :contract_to_id, :start_date, :end_date, :plan_id, :payment_type, :training_start_date, :training_end_date)
  end

end
