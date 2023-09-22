class Company::CommitmentProfilesController < ApplicationController
  before_action :authenticate_company_user!
  before_action :set_company_commitment_profile, only: %i[ show home home_form about_us about_us_form recruitment recruitment_form member member_form edit update destroy ]
 
  authorize_resource class: 'Company::Company'
  
  def home
  end

  def home_form
  end

  def about_us
  end

  def about_us_form
  end

  def recruitment
    set_user_company
  end

  def recruitment_form
    set_user_company
  end

  def member
  end

  def member_form
  end
  
  # POST /company/commitment_profiles or /company/commitment_profiles.json
  def create
    @company_commitment_profile = Company::Company.new(company_commitment_profile_params)
    respond_to do |format|
      if @company_commitment_profile.save
        # keep stay own page after save
        if params[:company_company][:form_name] == "home_form"
          format.html { redirect_to home_company_commitment_profiles_path}
          flash[:success] = [t('common.create_success'), t('commitment_profile.title.commitment_profile_title')]
        elsif  params[:company_company][:form_name] == "about_us_form"
          format.html { redirect_to about_us_company_commitment_profiles_path}
          flash[:success] = [t('common.create_success'), t('commitment_profile.title.about_us_title')]
        elsif  params[:company_company][:form_name] == "member_form"
          format.html { redirect_to member_company_commitment_profiles_path}
          flash[:success] = [t('common.create_success'), t('commitment_profile.title.member_title')]
        else
          format.html { redirect_to recruitment_company_commitment_profiles_path}
          flash[:success] = [t('common.create_success'),t('commitment_profile.title.recruitment_title')]
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company_commitment_profile.errors, status: :unprocessable_entity }
        flash[:error] = [t('common.create_error'), t('commitment_profile.title.commitment_profile_title')]
      end
    end
  end

  # PATCH/PUT /company/commitment_profiles/1 or /company/commitment_profiles/1.json
  def update
    respond_to do |format|
      @company_commitment_profile.image.purge if params[:company_company][:imageFlag] == 'true'
      if @company_commitment_profile.update(company_commitment_profile_params)         
        # keep stay own page after update
        if params[:company_company][:form_name] == "home_form"
          # To delete upload logo image
          if params[:company_company][:imageFlag] == "true"
            @company_commitment_profile.image.purge
          end
          unless params[:company_company][:image_data].eql?"false"
            blob = convert_Base64_imgData(params[:company_company][:image_data])
            @company_commitment_profile.image.attach(blob)
            params[:company_company][:image_data] = false
          end  
           # To delete upload cover image
          if params[:company_company][:coverImageFlag] == "true"
            @company_commitment_profile.cover_photo.purge
          end
          unless params[:company_company][:cover_image_data].eql?"false"
            blob = convert_Base64_imgData(params[:company_company][:cover_image_data])
            @company_commitment_profile.cover_photo.attach(blob)
            params[:company_company][:cover_image_data] = false
          end  
          format.html { redirect_to home_company_commitment_profiles_path}
          flash[:success] = [t('common.update_success'), t('commitment_profile.title.commitment_profile_title')]
        elsif  params[:company_company][:form_name] == "about_us_form"
          format.html { redirect_to about_us_company_commitment_profiles_path}
          flash[:success] = [t('common.update_success'), t('commitment_profile.title.about_us_title')]
        elsif  params[:company_company][:form_name] == "member_form"
          format.html { redirect_to member_company_commitment_profiles_path}
          flash[:success] = [t('common.update_success'), t('commitment_profile.title.member_title')]
        else
          format.html { redirect_to recruitment_company_commitment_profiles_path}
          flash[:success] = [t('common.update_success'), t('commitment_profile.title.recruitment_title')]
        end
      else
        if params[:company_company][:form_name] == "home_form"
          format.html { render home_form_company_commitment_profiles_path}
          flash[:error] = [t('common.update_error'), t('commitment_profile.title.commitment_profile_title')]
        elsif  params[:company_company][:form_name] == "about_us_form"
          format.html { render about_us_form_company_commitment_profiles_path}
          flash[:error] = [t('common.update_error'), t('commitment_profile.title.about_us_title')]
        elsif  params[:company_company][:form_name] == "member_form"
          format.html { render member_form_company_commitment_profiles_path}
          flash[:error] = [t('common.update_error'), t('commitment_profile.title.member_title')]
        else
          format.html { render recruitment_form_company_commitment_profiles_path}
          flash[:error] = [t('common.update_error'), t('commitment_profile.title.recruitment_title')]
        end
        format.json { render json: @company_commitment_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company/commitment_profiles/1 or /company/commitment_profiles/1.json
  # def destroy
  #   @company_commitment_profile.destroy
  #   respond_to do |format|
  #     format.html { redirect_to company_commitment_profiles_url, notice: "Commitment profile was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_commitment_profile
      @company_commitment_profile = current_company
    end

    def set_user_company
      @user_company = current_company
    end

    # Only allow a list of trusted parameters through.
    def company_commitment_profile_params
      params.require(:company_company).permit(:company_message, :other_message, :company_vision_mission, :what_we_do, :how_we_do, :about_our_team, :member_message, :experience_requirements, :fresher_requirements, :fresher_second_requirements, :not_company_edit, :home_edit, :about_us_edit, :cover_photo, :image, :m_industry_id, :job_info, :employee_count_string, :company_intro, :history, :image_data)
    end
end