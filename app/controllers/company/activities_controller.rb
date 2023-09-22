class Company::ActivitiesController < ApplicationController
  before_action :authenticate_company_user!
  before_action :set_company_activity, only: %i[ show edit update destroy]
  load_and_authorize_resource param_method: :company_activity_params

  # GET /company/activities or /company/activities.json
  def index
    @company_commitment_profile = current_company
    @company_activities = Company::Activity.where(company_id: current_company.id).order("created_at desc")
    @company_activities = Kaminari.paginate_array(@company_activities).page(params[:page]).per(6)
  end

  # GET /company/activities/1 or /company/activities/1.json
  def show
  end

  # GET /company/activities/new
  def new
    @company_commitment_profile = current_company
    @company_activity = Company::Activity.new
  end

  # GET /company/activities/1/edit
  def edit
  end

  # POST /company/activities or /company/activities.json
  def create
    @company_activity = Company::Activity.new(company_activity_params)
    @company_activity.company_id = current_company.id

    # To delete upload cover image
    if params[:company_activity][:coverImageFlag] == "true"
      @company_activity.thumbnail.purge
    end
    unless params[:company_activity][:cover_image_data].eql?"false"
      blob = convert_Base64_imgData(params[:company_activity][:cover_image_data])
      @company_activity.thumbnail.attach(blob)
      params[:company_activity][:cover_image_data] = false
    end  

    # To delete upload video
    if params[:company_activity][:have_video_clip_flag] == "true"
      @company_activity.video_clip.purge
    end

    respond_to do |format|
      if @company_activity.save
        format.html { redirect_to @company_activity, notice: "Activity was successfully created." }
        format.json { render :show, status: :created, location: @company_activity }
      else
        @company_commitment_profile = current_company
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company/activities/1 or /company/activities/1.json
  def update
    # To delete upload cover image
    if params[:company_activity][:coverImageFlag] == "true"
      @company_activity.thumbnail.purge
    end
    unless params[:company_activity][:cover_image_data].eql?"false"
      blob = convert_Base64_imgData(params[:company_activity][:cover_image_data])
      @company_activity.thumbnail.attach(blob)
      params[:company_activity][:cover_image_data] = false
    end  

    # To delete upload video
    if params[:company_activity][:have_video_clip_flag] == "true"
      @company_activity.video_clip.purge
    end
    
    respond_to do |format|
      if @company_activity.update(company_activity_params)
        format.html { redirect_to @company_activity, notice: "Activity was successfully updated." }
        format.json { render :show, status: :ok, location: @company_activity }
      else
        @company_commitment_profile = current_company
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company/activities/1 or /company/activities/1.json
  def destroy
    @company_activity.destroy
    respond_to do |format|
      format.html { redirect_to company_activities_url, notice: "Activity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_activity
      @company_activity = Company::Activity.find(params[:id])
      @company_commitment_profile = current_company
    end

    # Only allow a list of trusted parameters through.
    def company_activity_params
      params.require(:company_activity).permit(:title, :desc, :video_clip, :thumbnail, :company_id, :delete_flg)
    end
end
