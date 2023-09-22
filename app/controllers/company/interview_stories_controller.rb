class Company::InterviewStoriesController < ApplicationController
  before_action :authenticate_company_user!
  before_action :set_company_interview_story, only: %i[ show edit update destroy ]
  before_action :set_company, only: %i[index create new show edit update destroy]
  load_and_authorize_resource param_method: :company_interview_story_params
  include CommonHelper
  # GET /company/interview_stories or /company/interview_stories.json
  def index
    @company_interview_story_lists = Company::InterviewStory.where(:company_id => current_company.id).reverse
    @company_interview_story_lists = Kaminari.paginate_array(@company_interview_story_lists).page(params[:page]).per(6)
    @company_interview_story = Company::InterviewStory.new
  end

  # GET /company/interview_stories/1 or /company/interview_stories/1.json
  def show   
  end

  # GET /company/interview_stories/new
  def new
    @company_interview_story = Company::InterviewStory.new
    @company_interview_story_lists = Company::InterviewStory.where(:company_id => current_company.id)
  end

  # GET /company/interview_stories/1/edit
  def edit   
  end

  # POST /company/interview_stories or /company/interview_stories.json
  def create
    @company_interview_story = Company::InterviewStory.new(company_interview_story_params)
    @company_interview_story.user_id = current_company_user.id
    @company_interview_story.company_id = current_company.id
    respond_to do |format|
      if @company_interview_story.save
        save_created_user_img
        format.html { render :show, notice: "Interview story was successfully created." }
        format.json { render :show, status: :created, location: @company_interview_story }
        flash[:success] = [t('common.create_success'), t('interview_story.title.create_interview_story_title')]
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company_interview_story.errors, status: :unprocessable_entity }
        flash[:error] = [t('common.create_error'), t('interview_story.title.create_interview_story_title')]
      end
    end
  end

  # PATCH/PUT /company/interview_stories/1 or /company/interview_stories/1.json
  def update
    respond_to do |format|
      if @company_interview_story.update(company_interview_story_params)
        # To delete upload image
        if params[:company_interview_story][:imageFlag] == "true"
          @company_interview_story.image.purge
        end
        save_created_user_img
        format.html { render :show, notice: "Interview story was successfully updated." }
        format.json { render :new, status: :ok, location: @company_interview_story }
        flash[:success] = [t('common.update_success'), t('interview_story.title.edit_story')]
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company_interview_story.errors, status: :unprocessable_entity }
        flash[:error] = [t('common.update_error'), t('interview_story.title.edit_story')]
      end
    end
  end

  # DELETE /company/interview_stories/1 or /company/interview_stories/1.json
  def destroy
    @company_interview_story.destroy
    respond_to do |format|
      format.html { redirect_to company_interview_stories_url, notice: "Interview story was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def save_created_user_img
    unless params[:company_interview_story][:image_data].eql?"false"
      blob = convert_Base64_imgData(params[:company_interview_story][:image_data])
      @company_interview_story.image.attach(blob)
      params[:company_interview_story][:image_data] = false
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_interview_story
      @company_interview_story = Company::InterviewStory.find(params[:id])   
    end

    def set_company
      @company_commitment_profile = current_company
    end

    # Only allow a list of trusted parameters through.
    def company_interview_story_params
      params.require(:company_interview_story).permit(:title, :review)
    end
end
