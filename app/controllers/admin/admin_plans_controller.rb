class Admin::AdminPlansController < ApplicationController
  before_action :set_admin_plan, only: %i[ show edit update destroy ]
  include CommonHelper
  layout 'layouts/template/admin'

  # GET /admin/admin_plans or /admin/admin_plans.json
  def index
    @admin_plans = Admin::AdminPlan.all
    @results = Kaminari.paginate_array(@admin_plans).page(params[:page]).per(12)
  end

  # GET /admin/admin_plans/1 or /admin/admin_plans/1.json
  def show
  end

  # GET /admin/admin_plans/new
  def new
    @admin_plan = Admin::AdminPlan.new
  end

  # GET /admin/admin_plans/1/edit
  def edit
  end

  # POST /admin/admin_plans or /admin/admin_plans.json
  def create
    @admin_plan = Admin::AdminPlan.new(admin_plan_params)
    @admin_plan.admin_id = current_admin.id
    respond_to do |format|
      if @admin_plan.save
        format.html { redirect_to @admin_plan, notice: "Admin plan was successfully created." }
        format.json { render :show, status: :created, location: @admin_plan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/admin_plans/1 or /admin/admin_plans/1.json
  def update
    respond_to do |format|
      if @admin_plan.update(admin_plan_params)
        format.html { redirect_to @admin_plan, notice: "Admin plan was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_plan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/admin_plans/1 or /admin/admin_plans/1.json
  def destroy
    @admin_plan.destroy
    respond_to do |format|
      format.html { redirect_to admin_admin_plans_url, notice: "Admin plan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_plan
      @admin_plan = Admin::AdminPlan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_plan_params
      # params.fetch(:admin_admin_plan, {})
      params.require(:admin_admin_plan).permit(:name, :fee, :content)
    end
end
