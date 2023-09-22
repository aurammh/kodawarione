class Company::CommitmentAbilityController < ApplicationController
    include Student::AssessmentsHelper
    before_action :authenticate_company_user!    
    authorize_resource class: 'Company::CompanyCommitmentAbility'
    def index
        @student_assessment = Student::Assessment.find_by(student_id: params[:id])
        selfEevaluationChart_rank(@student_assessment)
        potentialDesireType(@student_assessment)
        behavioralTraitTypeChart_rank(@student_assessment)
        @commitment_ability_list = MCommitmentAbility.select(:id,:name).order(id: :asc)
        @commitment_ability_detail_results = Company::CompanyCommitmentAbilityDetail.select("ability_value,ability_reason,m_commitment_abilities_id,m_commitment_abilities.name,company_commitment_abilities.updated_at")
        .joins("INNER JOIN m_commitment_abilities ON m_commitment_abilities.id = company_commitment_ability_details.m_commitment_abilities_id")
        .joins("INNER JOIN company_commitment_abilities on company_commitment_abilities.id = company_commitment_ability_details.company_commitment_ability_id")
        .where("company_commitment_ability_details.company_id = ? and company_commitment_abilities.status = 'active'", current_company.id)
        # For commitment chart
        commitment_ability_chart_for_company(current_company.id)
    end

    def show
        @commitment_ability_list = MCommitmentAbility.select(:id,:name).order(id: :asc)
        @commitment_ability_detail_results = Company::CompanyCommitmentAbilityDetail.select("ability_value,ability_reason,m_commitment_abilities_id,m_commitment_abilities.name,company_commitment_abilities.updated_at")
        .joins("INNER JOIN m_commitment_abilities ON m_commitment_abilities.id = company_commitment_ability_details.m_commitment_abilities_id")
        .joins("INNER JOIN company_commitment_abilities on company_commitment_abilities.id = company_commitment_ability_details.company_commitment_ability_id")
        .where("company_commitment_ability_details.company_id = ? and company_commitment_abilities.status = 'active'", current_company.id)
    end
   
    def update
        student_list = Student::StudentCommitmentAbilityDetail.find_by_sql("
            select student_id, a[1] ability_1_id, a[2] ability_2_id, a[3] ability_3_id, b[1] ability_1_name, b[2] ability_2_name, b[3] ability_3_name from (
            select student_commitment_ability_details.student_id, array_agg(m_commitment_abilities_id) a, array_agg(m.name) b
            from student_commitment_ability_details
            INNER JOIN student_commitment_abilities on student_commitment_abilities.id = student_commitment_ability_details.student_commitment_ability_id
            INNER JOIN m_commitment_abilities m on m.id = student_commitment_ability_details.m_commitment_abilities_id
            Where student_commitment_abilities.status = 'active'
            group by 1
            order by 1) 
            student_commitment_ability_details")

        # update in company commitment ability table 
        company_commitment_ability = Company::CompanyCommitmentAbility.where("company_id = ? and status = ? ", current_company.id, "active").take
        if company_commitment_ability.present?          
            company_commitment_ability.status = "inactive"
            company_commitment_ability.save
        end
        # new insert in company commitment ability table
        company_commitment_ability = Company::CompanyCommitmentAbility.new
        company_commitment_ability.company_id = current_company.id
        company_commitment_ability.status = "active"
        company_commitment_ability.save

        company_commitment_ability = Company::CompanyCommitmentAbility.where("company_id = ? and status = ? ", current_company.id, "active").take

        # new company commitment details table            
        params[:company_ability_data].each do |company_commitment_detail|
            @company_commitment_detail = Company::CompanyCommitmentAbilityDetail.new(company_commitment_detail_params(company_commitment_detail))
            @company_commitment_detail.company_id = current_company.id
            @company_commitment_detail.company_commitment_ability_id = company_commitment_ability.id
            @company_commitment_detail.save                                
        end       

        student_list.each_with_index do |stu_value, s_index|
            # save company student matched result table
            matched_result = PreCalculatedAbilityResults.find_by_sql("(SELECT ability_1_id,ability_2_id,matched_percentage	
						FROM pre_calculated_ability_results 
						WHERE matched_percentage = 
   							( SELECT MAX(matched_percentage) FROM pre_calculated_ability_results
    							 Where ability_1_id = #{params[:company_ability_data][0][:m_commitment_abilities_id]} and (ability_2_id = #{stu_value.ability_1_id} or ability_2_id = #{stu_value.ability_2_id} or ability_2_id = #{stu_value.ability_3_id})  
   									) and ability_1_id = #{params[:company_ability_data][0][:m_commitment_abilities_id]} and (ability_2_id = #{stu_value.ability_1_id} or ability_2_id = #{stu_value.ability_2_id} or ability_2_id = #{stu_value.ability_3_id})
						limit 1)    
                        Union ALL
                        (SELECT ability_1_id,ability_2_id,matched_percentage
                        FROM pre_calculated_ability_results 
                        WHERE matched_percentage = 
                        ( SELECT MAX(matched_percentage) FROM pre_calculated_ability_results
                        Where ability_1_id = #{params[:company_ability_data][1][:m_commitment_abilities_id]} and (ability_2_id =#{stu_value.ability_1_id} or ability_2_id = #{stu_value.ability_2_id} or ability_2_id = #{stu_value.ability_3_id})  
                        ) and ability_1_id = #{params[:company_ability_data][1][:m_commitment_abilities_id]} and (ability_2_id =#{stu_value.ability_1_id} or ability_2_id = #{stu_value.ability_2_id} or ability_2_id = #{stu_value.ability_3_id})
                        limit 1)
                        Union ALL
                        (SELECT ability_1_id,ability_2_id,matched_percentage
                        FROM pre_calculated_ability_results 
                        WHERE matched_percentage = 
                        ( SELECT MAX(matched_percentage) FROM pre_calculated_ability_results
                        Where ability_1_id = #{params[:company_ability_data][2][:m_commitment_abilities_id]} and (ability_2_id =#{stu_value.ability_1_id} or ability_2_id = #{stu_value.ability_2_id} or ability_2_id = #{stu_value.ability_3_id})  
                        ) and ability_1_id = #{params[:company_ability_data][2][:m_commitment_abilities_id]} and (ability_2_id =#{stu_value.ability_1_id} or ability_2_id = #{stu_value.ability_2_id} or ability_2_id = #{stu_value.ability_3_id})
                        limit 1)")

            exist_data = Company::CompanyStudentMatchedResult.where("student_id = ? and company_id = ? ", stu_value.student_id, current_company.id).take

            if exist_data.present?
                exist_data.overall_result =  ((matched_result[0][:matched_percentage] + matched_result[1][:matched_percentage] + matched_result[2][:matched_percentage])/3).round(2)
                exist_data.ability_1_percentage = matched_result[0][:matched_percentage]
                exist_data.ability_2_percentage = matched_result[1][:matched_percentage]
                exist_data.ability_3_percentage = matched_result[2][:matched_percentage]
                exist_data.student_status = nil
                exist_data.student_id =  stu_value.student_id
                exist_data.company_id = current_company.id
                exist_data.result_details = [
                    {
                        "student_ability_id" =>   matched_result[0][:ability_2_id],
                        "student_ability_name" => stu_value.ability_1_name,
                        "company_ability_id" =>  params[:company_ability_data][0][:m_commitment_abilities_id],
                        "company_ability_name" => params[:company_ability_data][0][:name],
                        "result" => matched_result[0][:matched_percentage]            
                    },
                    {
                        "student_ability_id" =>  matched_result[1][:ability_2_id], 
                        "student_ability_name" => stu_value.ability_2_name,
                        "company_ability_id" =>  params[:company_ability_data][1][:m_commitment_abilities_id],
                        "company_ability_name" => params[:company_ability_data][1][:name],
                        "result" => matched_result[1][:matched_percentage]              
                    },
                    {
                        "student_ability_id" =>  matched_result[2][:ability_2_id], 
                        "student_ability_name" => stu_value.ability_3_name,
                        "company_ability_id" => params[:company_ability_data][2][:m_commitment_abilities_id],
                        "company_ability_name" => params[:company_ability_data][2][:name],
                        "result" => matched_result[2][:matched_percentage]             
                    }
                ]
                exist_data.save
            else
                db_matched_result = Company::CompanyStudentMatchedResult.new
                db_matched_result.overall_result =  ((matched_result[0][:matched_percentage] + matched_result[1][:matched_percentage] + matched_result[2][:matched_percentage])/3).round(2)
                db_matched_result.ability_1_percentage = matched_result[0][:matched_percentage]
                db_matched_result.ability_2_percentage = matched_result[1][:matched_percentage]
                db_matched_result.ability_3_percentage = matched_result[2][:matched_percentage]
                db_matched_result.student_status = nil
                db_matched_result.student_id =  stu_value.student_id
                db_matched_result.company_id = current_company.id
                db_matched_result.result_details = [
                    {
                        "student_ability_id" =>   matched_result[0][:ability_2_id],
                        "student_ability_name" => stu_value.ability_1_name,
                        "company_ability_id" =>  params[:company_ability_data][0][:m_commitment_abilities_id],
                        "company_ability_name" => params[:company_ability_data][0][:name],
                        "result" => matched_result[0][:matched_percentage]            
                    },
                    {
                        "student_ability_id" =>  matched_result[1][:ability_2_id], 
                        "student_ability_name" => stu_value.ability_2_name,
                        "company_ability_id" =>  params[:company_ability_data][1][:m_commitment_abilities_id],
                        "company_ability_name" => params[:company_ability_data][1][:name],
                        "result" => matched_result[1][:matched_percentage]              
                    },
                    {
                        "student_ability_id" =>  matched_result[2][:ability_2_id], 
                        "student_ability_name" => stu_value.ability_3_name,
                        "company_ability_id" => params[:company_ability_data][2][:m_commitment_abilities_id],
                        "company_ability_name" => params[:company_ability_data][2][:name],
                        "result" => matched_result[2][:matched_percentage]             
                    }
                ]
                db_matched_result.save 
            end 

            #update student company matched result table
            updated_matched_result = PreCalculatedAbilityResults.find_by_sql("(SELECT ability_1_id,ability_2_id,matched_percentage, name as student_ability_name	
                                        FROM pre_calculated_ability_results 
                                        INNER JOIN m_commitment_abilities m on m.id = pre_calculated_ability_results.ability_2_id
                                        WHERE matched_percentage = 
                                            ( SELECT MAX(matched_percentage) FROM pre_calculated_ability_results
                                                Where ability_1_id = #{stu_value.ability_1_id} and (ability_2_id = #{params[:company_ability_data][0][:m_commitment_abilities_id]} or ability_2_id = #{params[:company_ability_data][1][:m_commitment_abilities_id]} or ability_2_id = #{params[:company_ability_data][2][:m_commitment_abilities_id]})  
                                            ) and ability_1_id = #{stu_value.ability_1_id} and (ability_2_id = #{params[:company_ability_data][0][:m_commitment_abilities_id]} or ability_2_id = #{params[:company_ability_data][1][:m_commitment_abilities_id]} or ability_2_id = #{params[:company_ability_data][2][:m_commitment_abilities_id]})
                                        limit 1)    
                                        Union ALL
                                        (SELECT ability_1_id,ability_2_id,matched_percentage, name as student_ability_name
                                        FROM pre_calculated_ability_results
                                        INNER JOIN m_commitment_abilities m on m.id = pre_calculated_ability_results.ability_2_id 
                                        WHERE matched_percentage = 
                                            ( SELECT MAX(matched_percentage) FROM pre_calculated_ability_results
                                                 Where ability_1_id = #{stu_value.ability_2_id} and (ability_2_id = #{params[:company_ability_data][0][:m_commitment_abilities_id]} or ability_2_id = #{params[:company_ability_data][1][:m_commitment_abilities_id]} or ability_2_id = #{params[:company_ability_data][2][:m_commitment_abilities_id]})  
                                             ) and ability_1_id = #{stu_value.ability_2_id} and (ability_2_id =#{params[:company_ability_data][0][:m_commitment_abilities_id]} or ability_2_id = #{params[:company_ability_data][1][:m_commitment_abilities_id]} or ability_2_id = #{params[:company_ability_data][2][:m_commitment_abilities_id]})
                                        limit 1)
                                        Union ALL
                                        (SELECT ability_1_id,ability_2_id,matched_percentage, name as student_ability_name
                                        FROM pre_calculated_ability_results 
                                        INNER JOIN m_commitment_abilities m on m.id = pre_calculated_ability_results.ability_2_id
                                        WHERE matched_percentage = 
                                            ( SELECT MAX(matched_percentage) FROM pre_calculated_ability_results
                                            Where ability_1_id = #{stu_value.ability_3_id} and (ability_2_id =#{params[:company_ability_data][0][:m_commitment_abilities_id]} or ability_2_id = #{params[:company_ability_data][1][:m_commitment_abilities_id]} or ability_2_id = #{params[:company_ability_data][2][:m_commitment_abilities_id]})  
                                            ) and ability_1_id = #{stu_value.ability_3_id} and (ability_2_id =#{params[:company_ability_data][0][:m_commitment_abilities_id]} or ability_2_id = #{params[:company_ability_data][1][:m_commitment_abilities_id]} or ability_2_id = #{params[:company_ability_data][2][:m_commitment_abilities_id]})
                                        limit 1)")
            exist_data = Student::StudentCompanyMatchedResult.where("student_id = ? and company_id = ? ", stu_value.student_id, current_company.id).take
            if exist_data.present?
                exist_data.overall_result = ((updated_matched_result[0][:matched_percentage] + updated_matched_result[1][:matched_percentage] + updated_matched_result[2][:matched_percentage])/3).round(2) 
                exist_data.ability_1_percentage = updated_matched_result[0][:matched_percentage]
                exist_data.ability_2_percentage = updated_matched_result[1][:matched_percentage]
                exist_data.ability_3_percentage = updated_matched_result[2][:matched_percentage]
                exist_data.company_status = nil
                exist_data.student_id =  stu_value.student_id
                exist_data.company_id = current_company.id
                exist_data.result_details = [
                    {
                        "student_ability_id" =>  stu_value.ability_1_id, 
                        "student_ability_name" => stu_value.ability_1_name,
                        "company_ability_id" =>  updated_matched_result[0][:ability_2_id],
                        "company_ability_name" => updated_matched_result[0][:student_ability_name],
                        "result" => updated_matched_result[0][:matched_percentage]            
                    },
                    {
                        "student_ability_id" =>  stu_value.ability_2_id, 
                        "student_ability_name" => stu_value.ability_2_name,
                        "company_ability_id" =>  updated_matched_result[1][:ability_2_id],
                        "company_ability_name" => updated_matched_result[1][:student_ability_name],
                        "result" => updated_matched_result[1][:matched_percentage]              
                    },
                    {
                        "student_ability_id" =>  stu_value.ability_3_id, 
                        "student_ability_name" => stu_value.ability_3_name,
                        "company_ability_id" =>  updated_matched_result[2][:ability_2_id],
                        "company_ability_name" => updated_matched_result[2][:student_ability_name],
                        "result" => updated_matched_result[2][:matched_percentage]             
                    }
                ]
                exist_data.save
            else
                db_matched_result = Student::StudentCompanyMatchedResult.new
                db_matched_result.overall_result = ((updated_matched_result[0][:matched_percentage] + updated_matched_result[1][:matched_percentage] + updated_matched_result[2][:matched_percentage])/3).round(2) 
                db_matched_result.ability_1_percentage = updated_matched_result[0][:matched_percentage]
                db_matched_result.ability_2_percentage = updated_matched_result[1][:matched_percentage]
                db_matched_result.ability_3_percentage = updated_matched_result[2][:matched_percentage]
                db_matched_result.company_status = nil
                db_matched_result.student_id =  stu_value.student_id
                db_matched_result.company_id = current_company.id
                db_matched_result.result_details = [
                    {
                        "student_ability_id" =>  stu_value.ability_1_id, 
                        "student_ability_name" => stu_value.ability_1_name,
                        "company_ability_id" =>  updated_matched_result[0][:ability_2_id],
                        "company_ability_name" => updated_matched_result[0][:student_ability_name],
                        "result" => updated_matched_result[0][:matched_percentage]            
                    },
                    {
                        "student_ability_id" =>  stu_value.ability_2_id, 
                        "student_ability_name" => stu_value.ability_2_name,
                        "company_ability_id" =>  updated_matched_result[1][:ability_2_id],
                        "company_ability_name" => updated_matched_result[1][:student_ability_name],
                        "result" => updated_matched_result[1][:matched_percentage]              
                    },
                    {
                        "student_ability_id" =>  stu_value.ability_3_id, 
                        "student_ability_name" => stu_value.ability_3_name,
                        "company_ability_id" =>  updated_matched_result[2][:ability_2_id],
                        "company_ability_name" => updated_matched_result[2][:student_ability_name],
                        "result" => updated_matched_result[2][:matched_percentage]             
                    }
                ]
                db_matched_result.save 
            end 
        end

        flash[:success] = [t('common.create_success'), t("company_assessment.title")]       
        render :json => {:status => 'ok'}  
    end

    private

    # Only allow a list of trusted parameters through.
    def company_commitment_detail_params(company_commitment_detail)
        company_commitment_detail.permit(:ability_value, :ability_reason, :m_commitment_abilities_id) 
    end
end
