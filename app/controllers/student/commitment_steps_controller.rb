class Student::CommitmentStepsController < ApplicationController
  before_action :authenticate_user!, :authorize_user!
  before_action :set_student, only: %i[show update]
  before_action :set_partner_list, only: %i[edit update show]
  include CommonHelper
  include Student::AssessmentsHelper
  include Wicked::Wizard
  steps :step1, :step2, :step3, :complete

  def show
    render_wizard
  end

  def update
    # To delete upload image
    @user_student.cover_photo.purge if params[:student_student][:imageFlag] == 'true' || params[:student_student][:coverImgFlag] == 'false'

    @user_student.is_std_commitment_step = true
    
    # Update data
    if @user_student.update(student_commitment_params(params[:id]))
      unless params[:student_student][:image_data].blank?
        unless params[:student_student][:image_data].eql? 'false'
          blob = convert_Base64_imgData(params[:student_student][:image_data])
          @user_student.cover_photo.attach(blob)
          params[:student_student][:image_data] = false
        end
      end   
    end
    render_wizard @user_student
    flash[:success] = [t('common.update_success'), t('student_commitment.title.student_commitment_title')]
  end

  def finish_wizard_path
    #student_students_path
    welcome_index_path
  end

  private

  def set_partner_list
    @partner_list = Partner::Partner.select(:id, :name)
  end

  def set_student
    @user_student = current_user.student
  end

  def student_commitment_params(step)
    permitted_attributes =  case step
                            when "step1"
                              [:nick_name,:current_address,:not_step_form,:birthday,:gender,:qualification_string, preferred_working_area: [] ]
                            when "step2"
                              [:commitment,:not_step_form]
                            when "step3"
                              [:cover_color,:cover_photo,:not_step_form]
                            end
    params.require(:student_student).permit(permitted_attributes).merge(std_commitment_step: step)
  end
end
