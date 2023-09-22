class Student::StudentCommitmentController < ApplicationController
  before_action :authenticate_user!, :authorize_user!
  before_action :set_user_student, only: %i[show edit assessment update index destroy]
  before_action :set_partner_list, only: %i[edit update show]
  include CommonHelper
  include Student::AssessmentsHelper

  def edit
    set_user_student
  end

  def assessment
    @student_assessment = Student::Assessment.find_by(student_id: params[:id])
    selfEevaluationChart_rank(@student_assessment)
    potentialDesireType(@student_assessment)
    behavioralTraitTypeChart_rank(@student_assessment)
  end 

  def update     
    # convert json data type to array
    set_user_student
    
    @user_student.is_std_commitment_step = false
    @user_student.is_kodawari_assessment = true
    
    respond_to do |format|
      # To delete upload image
      @user_student.cover_photo.purge if params[:student_student][:imageFlag] == 'true' || params[:student_student][:coverImgFlag] == 'false'
      if @user_student.update(student_commitment_params)
        unless params[:student_student][:image_data].blank?
          unless params[:student_student][:image_data].eql? 'false'
            blob = convert_Base64_imgData(params[:student_student][:image_data])
            @user_student.cover_photo.attach(blob)
            params[:student_student][:image_data] = false
          end
        end

        if !params[:student_student][:route_check].blank?
          format.html { redirect_to student_student_commitment_assessment_path }
          flash[:success] = [t('common.update_success'), t('student.assessment.kodawari_assessment_title')]
        else
          format.html { redirect_to edit_student_student_commitment_path }
          format.json { render :edit, status: :ok, location: @user_student }
          flash[:success] = [t('common.update_success'), t('student_commitment.title.student_commitment_title')]
        end
      else
        if !params[:student_student][:route_check].blank?
          format.html { render 'student/student_commitment/kodawari/kodawari_assessment' }
          format.json { render json: @user_student.errors, status: :unprocessable_entity }
          flash[:error] = [t('common.update_error'), t('student.assessment.kodawari_assessment_title')]
        else
         
          format.html { render :edit }
          format.json { render json: @user_student.errors }
          flash[:error] = [t('common.update_error'), t('student_commitment.title.student_commitment_title')]
        end
      end
    end
  end

  private

  def set_partner_list
    @partner_list = Partner::Partner.select(:id, :name)
  end

  def set_user_student
    @user_student = current_user.student
  end

  # Only allow a list of trusted parameters through.
  def student_commitment_params
    params.require(:student_student).permit(:nick_name, :current_address, :commitment,:birthday,:gender,:qualification_string, :cover_color, :cover_photo, preferred_working_area: [])
  end
end
