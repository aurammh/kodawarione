class Student::CommitmentAbilityController < ApplicationController
    include Student::AssessmentsHelper
    before_action :authenticate_user!, :authorize_user!

    def index 
        @student_assessment = Student::Assessment.find_by(student_id: params[:id])
        selfEevaluationChart_rank(@student_assessment)
        potentialDesireType(@student_assessment)
        behavioralTraitTypeChart_rank(@student_assessment)
        @commitment_ability_list = MCommitmentAbility.select(:id,:name).order(id: :asc)
        @commitment_ability_detail_results = Student::StudentCommitmentAbilityDetail.select("ability_value,ability_reason,m_commitment_abilities_id,m_commitment_abilities.name,student_commitment_abilities.updated_at")
        .joins("INNER JOIN m_commitment_abilities ON m_commitment_abilities.id = student_commitment_ability_details.m_commitment_abilities_id")
        .joins("INNER JOIN student_commitment_abilities on student_commitment_abilities.id = student_commitment_ability_details.student_commitment_ability_id")
        .where("student_commitment_ability_details.student_id = ? and student_commitment_abilities.status = 'active'", current_user.student.id)
        # For commitment chart
        commitment_ability_chart(current_user)
    end

    def show
        @commitment_ability_list = MCommitmentAbility.select(:id,:name).order(id: :asc)
        @commitment_ability_detail_results = Student::StudentCommitmentAbilityDetail.select("ability_value,ability_reason,m_commitment_abilities_id,m_commitment_abilities.name,student_commitment_abilities.updated_at")
        .joins("INNER JOIN m_commitment_abilities ON m_commitment_abilities.id = student_commitment_ability_details.m_commitment_abilities_id")
        .joins("INNER JOIN student_commitment_abilities on student_commitment_abilities.id = student_commitment_ability_details.student_commitment_ability_id")
        .where("student_commitment_ability_details.student_id = ? and student_commitment_abilities.status = 'active'", current_user.student.id)
    end

    def update
        com_list = Company::CompanyCommitmentAbilityDetail.find_by_sql("
            select company_id, a[1] ability_1_id, a[2] ability_2_id, a[3] ability_3_id, b[1] ability_1_name, b[2] ability_2_name, b[3] ability_3_name from (
            select company_commitment_ability_details.company_id, array_agg(m_commitment_abilities_id) a, array_agg(m.name) b
            from company_commitment_ability_details
            INNER JOIN company_commitment_abilities on company_commitment_abilities.id = company_commitment_ability_details.company_commitment_ability_id
            INNER JOIN m_commitment_abilities m on m.id = company_commitment_ability_details.m_commitment_abilities_id
            Where company_commitment_abilities.status = 'active'
            group by 1
            order by 1) 
        company_commitment_ability_details")

        # update in student commitment ability table 
        student_commitment_ability = Student::StudentCommitmentAbility.where("student_id = ? and status = ? ", current_user.student.id, "active").take

        if student_commitment_ability.present?          
            student_commitment_ability.status = "inactive"
            student_commitment_ability.save
        end
        # new insert in student commitment ability table
        student_commitment_ability = Student::StudentCommitmentAbility.new
        student_commitment_ability.student_id = current_user.student.id
        student_commitment_ability.status = "active"
        student_commitment_ability.save

        student_commitment_ability = Student::StudentCommitmentAbility.where("student_id = ? and status = ? ", current_user.student.id, "active").take

        # new student commitment details table            
        params[:student_ability_data].each_with_index do |student_commitment_detail, index|
            @student_commitment_detail = Student::StudentCommitmentAbilityDetail.new(student_commitment_detail_params(student_commitment_detail))
            @student_commitment_detail.student_id = current_user.student.id
            @student_commitment_detail.student_commitment_ability_id = student_commitment_ability.id
            @student_commitment_detail.save  
        end          
        
        com_list.each_with_index do |com_value, c_index|
            # save student company matched result table
            matched_result = PreCalculatedAbilityResults.find_by_sql("(SELECT ability_1_id,ability_2_id,matched_percentage	
						FROM pre_calculated_ability_results 
						WHERE matched_percentage = 
   							( SELECT MAX(matched_percentage) FROM pre_calculated_ability_results
    							 Where ability_1_id = #{params[:student_ability_data][0][:m_commitment_abilities_id]} and (ability_2_id = #{com_value.ability_1_id} or ability_2_id = #{com_value.ability_2_id} or ability_2_id = #{com_value.ability_3_id})  
   									) and ability_1_id = #{params[:student_ability_data][0][:m_commitment_abilities_id]} and (ability_2_id = #{com_value.ability_1_id} or ability_2_id = #{com_value.ability_2_id} or ability_2_id = #{com_value.ability_3_id})
						limit 1)    
                        Union ALL
                        (SELECT ability_1_id,ability_2_id,matched_percentage
                        FROM pre_calculated_ability_results 
                        WHERE matched_percentage = 
                        ( SELECT MAX(matched_percentage) FROM pre_calculated_ability_results
                        Where ability_1_id = #{params[:student_ability_data][1][:m_commitment_abilities_id]} and (ability_2_id =#{com_value.ability_1_id} or ability_2_id = #{com_value.ability_2_id} or ability_2_id = #{com_value.ability_3_id})  
                        ) and ability_1_id = #{params[:student_ability_data][1][:m_commitment_abilities_id]} and (ability_2_id =#{com_value.ability_1_id} or ability_2_id = #{com_value.ability_2_id} or ability_2_id = #{com_value.ability_3_id})
                        limit 1)
                        Union ALL
                        (SELECT ability_1_id,ability_2_id,matched_percentage
                        FROM pre_calculated_ability_results 
                        WHERE matched_percentage = 
                        ( SELECT MAX(matched_percentage) FROM pre_calculated_ability_results
                        Where ability_1_id = #{params[:student_ability_data][2][:m_commitment_abilities_id]} and (ability_2_id =#{com_value.ability_1_id} or ability_2_id = #{com_value.ability_2_id} or ability_2_id = #{com_value.ability_3_id})  
                        ) and ability_1_id = #{params[:student_ability_data][2][:m_commitment_abilities_id]} and (ability_2_id =#{com_value.ability_1_id} or ability_2_id = #{com_value.ability_2_id} or ability_2_id = #{com_value.ability_3_id})
                        limit 1)")

            exist_data = Student::StudentCompanyMatchedResult.where("company_id = ? and student_id = ? ", com_value.company_id, current_user.student.id).take
            if exist_data.present?
                exist_data.overall_result =  ((matched_result[0][:matched_percentage] + matched_result[1][:matched_percentage] + matched_result[2][:matched_percentage])/3).round(2)
                exist_data.ability_1_percentage = matched_result[0][:matched_percentage]
                exist_data.ability_2_percentage = matched_result[1][:matched_percentage]
                exist_data.ability_3_percentage = matched_result[2][:matched_percentage]
                exist_data.company_status = nil
                exist_data.student_id =  current_user.student.id
                exist_data.company_id = com_value.company_id
                exist_data.result_details =[
                    {
                        "student_ability_id" =>   params[:student_ability_data][0][:m_commitment_abilities_id],
                        "student_ability_name" => params[:student_ability_data][0][:name],
                        "company_ability_id" => matched_result[0][:ability_2_id],
                        "company_ability_name" => com_value.ability_1_name,
                        "result" => matched_result[0][:matched_percentage]             
                    },
                    {
                        "student_ability_id" =>   params[:student_ability_data][1][:m_commitment_abilities_id],
                        "student_ability_name" => params[:student_ability_data][1][:name],
                        "company_ability_id" => matched_result[1][:ability_2_id],
                        "company_ability_name" => com_value.ability_2_name,
                        "result" => matched_result[1][:matched_percentage]            
                    },
                    {
                        "student_ability_id" =>   params[:student_ability_data][2][:m_commitment_abilities_id],
                        "student_ability_name" => params[:student_ability_data][2][:name],
                        "company_ability_id" => matched_result[2][:ability_2_id],
                        "company_ability_name" => com_value.ability_3_name,
                        "result" => matched_result[2][:matched_percentage]             
                    }
                ]
                exist_data.save
            else
                db_matched_result = Student::StudentCompanyMatchedResult.new
                db_matched_result.overall_result =  ((matched_result[0][:matched_percentage] + matched_result[1][:matched_percentage] + matched_result[2][:matched_percentage])/3).round(2)
                db_matched_result.ability_1_percentage = matched_result[0][:matched_percentage]
                db_matched_result.ability_2_percentage = matched_result[1][:matched_percentage]
                db_matched_result.ability_3_percentage = matched_result[2][:matched_percentage]
                db_matched_result.company_status = nil
                db_matched_result.student_id = current_user.student.id
                db_matched_result.company_id = com_value.company_id
                db_matched_result.result_details =[
                    {
                        "student_ability_id" =>   params[:student_ability_data][0][:m_commitment_abilities_id],
                        "student_ability_name" => params[:student_ability_data][0][:name],
                        "company_ability_id" =>  matched_result[0][:ability_2_id],
                        "company_ability_name" => com_value.ability_1_name,
                        "result" => matched_result[0][:matched_percentage]            
                    },
                    {
                        "student_ability_id" =>   params[:student_ability_data][1][:m_commitment_abilities_id],
                        "student_ability_name" => params[:student_ability_data][1][:name],
                        "company_ability_id" =>  matched_result[1][:ability_2_id],
                        "company_ability_name" => com_value.ability_2_name,
                        "result" => matched_result[1][:matched_percentage]              
                    },
                    {
                        "student_ability_id" =>   params[:student_ability_data][2][:m_commitment_abilities_id],
                        "student_ability_name" => params[:student_ability_data][2][:name],
                        "company_ability_id" =>  matched_result[2][:ability_2_id],
                        "company_ability_name" => com_value.ability_3_name,
                        "result" => matched_result[2][:matched_percentage]             
                    }
                ]
                db_matched_result.save 
            end 

            #update company student matched result table
            updated_matched_result = PreCalculatedAbilityResults.find_by_sql("(SELECT ability_1_id,ability_2_id,matched_percentage, name as student_ability_name	
                                        FROM pre_calculated_ability_results 
                                        INNER JOIN m_commitment_abilities m on m.id = pre_calculated_ability_results.ability_2_id
                                         WHERE matched_percentage = 
                                           ( SELECT MAX(matched_percentage) FROM pre_calculated_ability_results
                                         Where ability_1_id = #{com_value.ability_1_id} and (ability_2_id = #{params[:student_ability_data][0][:m_commitment_abilities_id]} or ability_2_id = #{params[:student_ability_data][1][:m_commitment_abilities_id]} or ability_2_id = #{params[:student_ability_data][2][:m_commitment_abilities_id]})  
                                       ) and ability_1_id = #{com_value.ability_1_id} and (ability_2_id = #{params[:student_ability_data][0][:m_commitment_abilities_id]} or ability_2_id = #{params[:student_ability_data][1][:m_commitment_abilities_id]} or ability_2_id = #{params[:student_ability_data][2][:m_commitment_abilities_id]})
                                     limit 1)    
                                      Union ALL
                                     (SELECT ability_1_id,ability_2_id,matched_percentage, name as student_ability_name
                                     FROM pre_calculated_ability_results
                                     INNER JOIN m_commitment_abilities m on m.id = pre_calculated_ability_results.ability_2_id 
                                      WHERE matched_percentage = 
                                  ( SELECT MAX(matched_percentage) FROM pre_calculated_ability_results
                                       Where ability_1_id = #{com_value.ability_2_id} and (ability_2_id = #{params[:student_ability_data][0][:m_commitment_abilities_id]} or ability_2_id = #{params[:student_ability_data][1][:m_commitment_abilities_id]} or ability_2_id = #{params[:student_ability_data][2][:m_commitment_abilities_id]})  
                                ) and ability_1_id = #{com_value.ability_2_id} and (ability_2_id =#{params[:student_ability_data][0][:m_commitment_abilities_id]} or ability_2_id = #{params[:student_ability_data][1][:m_commitment_abilities_id]} or ability_2_id = #{params[:student_ability_data][2][:m_commitment_abilities_id]})
                                limit 1)
                                 Union ALL
                              (SELECT ability_1_id,ability_2_id,matched_percentage, name as student_ability_name
                                  FROM pre_calculated_ability_results 
                                  INNER JOIN m_commitment_abilities m on m.id = pre_calculated_ability_results.ability_2_id
                                  WHERE matched_percentage = 
                              ( SELECT MAX(matched_percentage) FROM pre_calculated_ability_results
                                 Where ability_1_id = #{com_value.ability_3_id} and (ability_2_id =#{params[:student_ability_data][0][:m_commitment_abilities_id]} or ability_2_id = #{params[:student_ability_data][1][:m_commitment_abilities_id]} or ability_2_id = #{params[:student_ability_data][2][:m_commitment_abilities_id]})  
                         ) and ability_1_id = #{com_value.ability_3_id} and (ability_2_id =#{params[:student_ability_data][0][:m_commitment_abilities_id]} or ability_2_id = #{params[:student_ability_data][1][:m_commitment_abilities_id]} or ability_2_id = #{params[:student_ability_data][2][:m_commitment_abilities_id]})
                          limit 1)")

            exist_data = Company::CompanyStudentMatchedResult.where("student_id = ? and company_id = ? ", current_user.student.id, com_value.company_id).take
            if exist_data.present?
                exist_data.overall_result = ((updated_matched_result[0][:matched_percentage] + updated_matched_result[1][:matched_percentage] + updated_matched_result[2][:matched_percentage])/3).round(2) 
                exist_data.ability_1_percentage = updated_matched_result[0][:matched_percentage]
                exist_data.ability_2_percentage = updated_matched_result[1][:matched_percentage]
                exist_data.ability_3_percentage = updated_matched_result[2][:matched_percentage]
                exist_data.student_status = nil
                exist_data.student_id =  current_user.student.id
                exist_data.company_id = com_value.company_id
                exist_data.result_details =[
                    {
                        "student_ability_id" =>   updated_matched_result[0][:ability_2_id],
                        "student_ability_name" => updated_matched_result[0][:student_ability_name],
                        "company_ability_id" =>  com_value.ability_1_id,
                        "company_ability_name" => com_value.ability_1_name,
                        "result" => updated_matched_result[0][:matched_percentage]            
                    },
                    {
                        "student_ability_id" =>   updated_matched_result[1][:ability_2_id],
                        "student_ability_name" => updated_matched_result[1][:student_ability_name],
                        "company_ability_id" =>  com_value.ability_2_id,
                        "company_ability_name" => com_value.ability_2_name,
                        "result" => updated_matched_result[1][:matched_percentage]              
                    },
                    {
                        "student_ability_id" =>   updated_matched_result[2][:ability_2_id],
                        "student_ability_name" => updated_matched_result[2][:student_ability_name],
                        "company_ability_id" => com_value.ability_3_id,
                        "company_ability_name" =>  com_value.ability_3_name,
                        "result" => updated_matched_result[2][:matched_percentage]             
                    }
                ]
                exist_data.save
            else
                db_matched_result = Company::CompanyStudentMatchedResult.new
                db_matched_result.overall_result = ((updated_matched_result[0][:matched_percentage] + updated_matched_result[1][:matched_percentage] + updated_matched_result[2][:matched_percentage])/3).round(2) 
                db_matched_result.ability_1_percentage = updated_matched_result[0][:matched_percentage]
                db_matched_result.ability_2_percentage = updated_matched_result[1][:matched_percentage]
                db_matched_result.ability_3_percentage = updated_matched_result[2][:matched_percentage]
                db_matched_result.student_status = nil
                db_matched_result.student_id =  current_user.student.id
                db_matched_result.company_id = com_value.company_id
                db_matched_result.result_details =[
                    {
                        "student_ability_id" =>   updated_matched_result[0][:ability_2_id],
                        "student_ability_name" => updated_matched_result[0][:student_ability_name],
                        "company_ability_id" =>  com_value.ability_1_id,
                        "company_ability_name" => com_value.ability_1_name,
                        "result" => updated_matched_result[0][:matched_percentage]            
                    },
                    {
                        "student_ability_id" =>   updated_matched_result[1][:ability_2_id],
                        "student_ability_name" => updated_matched_result[1][:student_ability_name],
                        "company_ability_id" =>  com_value.ability_2_id,
                        "company_ability_name" => com_value.ability_2_name,
                        "result" => updated_matched_result[1][:matched_percentage]              
                    },
                    {
                        "student_ability_id" =>  updated_matched_result[2][:ability_2_id],
                        "student_ability_name" => updated_matched_result[2][:student_ability_name],
                        "company_ability_id" =>  com_value.ability_3_id,
                        "company_ability_name" => com_value.ability_3_name,
                        "result" => updated_matched_result[2][:matched_percentage]             
                    }
                ]
                db_matched_result.save 
            end 
        end

        flash[:success] = [t('common.update_success'), t('student.assessment.kodawari_assessment_title')]     
        render :json => {:status => 'ok'}  
    end

    private

    # Only allow a list of trusted parameters through.
    def student_commitment_detail_params(student_commitment_detail)
        student_commitment_detail.permit(:ability_value, :ability_reason, :m_commitment_abilities_id) 
    end
end
