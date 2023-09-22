class Student::StudentCompanyMatchedQuestionnaireResultController < ApplicationController
    before_action :authenticate_user!, :authorize_user!
    def index
        industry_query =    if params[:industry_id].blank?
                                params[:industry_id] = ""
                            else
                                "AND c.m_industry_id = '#{params[:industry_id]}'"
                            end

        area_query =    if params[:region_id].blank?
                            params[:region_id] = ""
                        else
                            "AND c.m_region_id = '#{params[:region_id]}'"
                        end

        keyword_query = if params[:keyword].blank?
                            params[:keyword] =  ""
                        else
                            "AND lower(regexp_replace(regexp_replace(c.company_name, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{params[:keyword].gsub(/'/, "''") }%')"
                        end

        percentage_query =  if params[:min_percentage].blank? && params[:max_percentage].blank?
                                ""
                            else
                                "AND matched_result BETWEEN #{params[:min_percentage]} AND #{params[:min_percentage]}"
                            end

        perKeyword = params[:per].nil? ? 6 : params[:per]

        @total_count = AssessmentMatchedResult.select("count(*) as total_count")
        .joins("INNER JOIN companies c on c.id = assessment_matched_results.company_id ")
        .joins("INNER JOIN m_regions r on r.id = c.m_region_id")
        .joins("FULL OUTER JOIN m_industries i on i.id = c.m_industry_id")
        .where("c.delete_flg = false AND (progress_details -> 3 ->> 'percent')::integer > 0 AND assessment_matched_results.student_id = #{current_user.student.id} and role = 'Student' #{industry_query} #{area_query} #{keyword_query} #{percentage_query}").take.total_count
        
        @matched_result = AssessmentMatchedResult.select("''as image,student_id,company_id,matched_result as overall_result,c.company_name,i.industry_name,c.company_established,c.display_address,c.website_url,json_build_object('label', '業種', 'value', i.industry_name) AS industry_result,json_build_object('label', '地域', 'value', r.region_name) AS region_result")
        .joins("INNER JOIN companies c on c.id = assessment_matched_results.company_id ")
        .joins("INNER JOIN m_regions r on r.id = c.m_region_id")
        .joins("FULL OUTER JOIN m_industries i on i.id = c.m_industry_id")
        .where("c.delete_flg = false AND (progress_details -> 3 ->> 'percent')::integer > 0 AND assessment_matched_results.student_id = #{current_user.student.id} and role = 'Student' #{industry_query} #{area_query} #{keyword_query}  #{percentage_query}")
        .order("assessment_matched_results.id asc")
        #.page(params[:page]).per(perKeyword)

        @matched_result = Kaminari.paginate_array(@matched_result).page(params[:page]).per(perKeyword)

        @matched_result.each_with_index do |r, index|
            company = Company::Company.find_by(id: r.company_id)
            @matched_result[index][:image] = company.image.attached? ? url_for(company.image) : nil
        end
    end
end