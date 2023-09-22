class Kodawarione::PlansController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_plan, only: %i[ show edit update destroy ]
  layout 'layouts/template/kodawarione'
  load_and_authorize_resource
  def index
    plans = Kodawarione::Plan.where(delete_flg: false).where(query_with_current_role("plans", "plans_index"))
    @plans = Kaminari.paginate_array(plans).page(params[:page]).per(12)
  end

  def new
    @plan = Kodawarione::Plan.new
  end

  def create
    @plan = Kodawarione::Plan.new(plan_params)
    @plan.created_id = current_admin.id
    @plan.plan_role_type = set_admin_role_type
    respond_to do |format|
      if @plan.save
        format.html { redirect_to @plan, notice: "Admin plan was successfully created." }
        format.json { render :show, status: :created, location: @plan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to @plan, notice: "Admin plan was successfully updated." }
        format.json { render :show, status: :ok, location: @plan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @plan.update_columns(delete_flg: true)
    respond_to do |format|
      format.html { redirect_to kodawarione_plans_path, notice: "Admin plan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_plan
      @plan = Kodawarione::Plan.find(params[:id])
    end

    def plan_params
      params.require(:kodawarione_plan).permit(:name, :fee, :content)
    end
end
