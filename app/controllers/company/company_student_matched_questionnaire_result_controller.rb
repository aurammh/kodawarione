class Company::CompanyStudentMatchedQuestionnaireResultController < ApplicationController
    before_action :authenticate_company_user!
    authorize_resource class: 'AssessmentMatchedResult'
    def index
        cookies[:previous_url] = '/company/company_student_matched_questionnaire_result'
        student_address_query = if params[:address].blank?
                                    params[:address] = ""
                                else
                                    "AND s.current_address = '#{params[:address]}'"
                                end

        desired_region_query = if params[:desired_location].blank?
                            params[:desired_location] = ""
                         else
                            "AND s.preferred_working_area && ARRAY#{params[:desired_location].map(&:to_i)}"
                         end

        desired_occupation_query =  if params[:jobcategory_id].blank?
                                        params[:jobcategory_id] = ""
                                    else
                                        "AND s.desire_job_type_id && ARRAY#{params[:jobcategory_id].map(&:to_i)}"
                                    end

        keyword_query = if params[:keyword].blank?
                            params[:keyword] =  ""
                        else
                            "AND lower(regexp_replace(regexp_replace(s.nick_name, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{params[:keyword].gsub(/'/, "''") }%')"
                        end
        
        percentage_query =  if params[:min_percentage].blank? && params[:max_percentage].blank?
                                ""
                            else
                                "AND matched_result BETWEEN #{params[:min_percentage]} AND #{params[:min_percentage]}"
                            end

        perKeyword = params[:per].nil? ? 6 : params[:per]

        @total_count = AssessmentMatchedResult.select("count(*) as total_count")
        .joins("INNER JOIN students s on s.id = assessment_matched_results.student_id")
        .joins("INNER JOIN m_prefectures p on p.id = s.current_address")
        .joins("INNER JOIN users u on u.id = s.user_id")
        .where("assessment_matched_results.company_id = #{current_company.id} and role = 'Company' #{student_address_query} #{desired_region_query} #{desired_occupation_query} #{keyword_query} #{percentage_query}").take.total_count
        
        @matched_result = AssessmentMatchedResult.select("json_build_object('label', '居住地', 'value', p.prefecture_name) AS current_address_result,'' as prefecture_name_result,'' as occupation_name_result,desire_job_type_id, preferred_working_area,'' as image,student_id,company_id,matched_result as overall_result,s.first_name, s.last_name, s.nick_name, s.gender, s.display_address,s.school_name, s.department_name, s.phone_no, date_part('year', age(s.birthday))::int as birthday,u.email")
        .joins("INNER JOIN students s on s.id = assessment_matched_results.student_id")
        .joins("INNER JOIN m_prefectures p on p.id = s.current_address")
        .joins("INNER JOIN users u on u.id = s.user_id")
        .where("assessment_matched_results.company_id = #{current_company.id} and role = 'Company' #{student_address_query} #{desired_region_query} #{desired_occupation_query} #{keyword_query} #{percentage_query}")
        .order("assessment_matched_results.id asc")
        #.page(params[:page]).per(perKeyword)

        @matched_result = Kaminari.paginate_array(@matched_result).page(params[:page]).per(perKeyword)

        @matched_result.each_with_index do |r, index|
            student = Student::Student.find_by(id: r.student_id)
            @matched_result[index][:image] = student.image.attached? ? url_for(student.image) : nil
            @matched_result[index][:image] = student.image.attached? ? url_for(student.image) : nil 
            # 希望勤務地
            if r.preferred_working_area.nil? 
                prefecture_name = nil
            else
                prefecture_name = get_prefecture_name_with_multi_select(r.preferred_working_area)
            end
            # 希望職種
            if r.desire_job_type_id.nil? 
                occupation_name = nil
            else
                occupation_name = get_occupation_name(r.desire_job_type_id)
            end
            @matched_result[index][:prefecture_name_result] = {"label" =>'希望勤務地',"value" => prefecture_name}
            @matched_result[index][:occupation_name_result] = {"label" => '希望職種',"value" => occupation_name} 
        end 
    end
end