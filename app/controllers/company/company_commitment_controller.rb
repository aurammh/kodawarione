class Company::CompanyCommitmentController < ApplicationController
    before_action :authenticate_company_user!
    before_action :set_company_company, only: %i[show edit  update ]
    include CommonHelper

    authorize_resource class: 'Company::CompanyCommitment'

    def edit
    end

    def show
        redirect_to  edit_company_company_commitment_path
    end

    def update
        set_company_company
        respond_to do |format|
            @update_second_time = @company_company.created_at == @company_company.updated_at ? false : true
            if @company_company.update(company_commitment_params)
                if !params[:company_company][:route_check].blank?
                    format.html { redirect_to company_company_assessment_path }
                    flash[:success] = [t('common.update_success'), t('student.assessment.kodawari_assessment_title')]
                else
                    if @update_second_time == true
                        format.html { redirect_to  edit_company_company_commitment_path}            
                        format.json { render :edit, status: :ok, location: @company_company }
                    else
                        format.html { redirect_to  company_companies_path}            
                        format.json { render :edit, status: :ok, location: @company_company }
                    end         
                    flash[:success] = [t('common.update_success'), t('student_commitment.title.student_commitment_title')]
                end                
            else
                if !params[:company_company][:route_check].blank?
                    format.html { render 'company/company_commitment/kodawari/kodawari_assessment' }
                    format.json { render json: @company_company.errors, status: :unprocessable_entity }
                    flash[:error] = [t('common.update_error'), t('student.assessment.kodawari_assessment_title')]
                else
                    format.html { render :edit }
                    format.json { render json: @company_company.errors }
                    flash[:error] = [t('common.update_error'), t('student_commitment.title.student_commitment_title')]
                end
            end
        end
    end

    private

    def set_company_company
        @company_company = @user_data
    end

    def company_commitment_params
        params.require(:company_company).permit(:company_name, :company_name_kana, :partner_id, :postal_code,
        :m_prefecture_id, :prefecture_name, :postalcode_city, :address, :m_region_id, :region_name, :display_address,:phone_no, :website_url,:company_established,:not_company_edit)
    end
end