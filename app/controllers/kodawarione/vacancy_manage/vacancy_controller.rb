class Kodawarione::VacancyManage::VacancyController < ApplicationController
    before_action :authenticate_admin!
    authorize_resource class: 'Company::Vacancy'
    layout 'layouts/template/kodawarione'

      def search_vacancy
        vacancy_startDate = params[:vacancy_startDate].blank? ? nil : params[:vacancy_startDate]
        # keyword = params[:company_name].blank? ? nil : params[:company_name].strip
        keyword = params[:vacancy_title].blank? ? nil : params[:vacancy_title].strip
        vacancy_endDate = params[:vacancy_endDate].blank? ? nil : params[:vacancy_endDate]
          if vacancy_startDate.blank? && !vacancy_endDate.blank?
            @results_vacancy = Company::Vacancy.vacancy_search_by_only_end_date(vacancy_endDate, keyword).where(query_with_current_role("companies", "vacancy_search"))
          elsif(!vacancy_startDate.blank? && vacancy_endDate.blank?)
            @results_vacancy = Company::Vacancy.vacancy_search_by_start_date(vacancy_startDate, keyword).where(query_with_current_role("companies", "vacancy_search"))
          elsif(!vacancy_startDate.blank? && !vacancy_endDate.blank?)
            @results_vacancy = Company::Vacancy.vacancy_search_by_between_two_date(vacancy_startDate,vacancy_endDate, keyword).where(query_with_current_role("companies", "vacancy_search"))
          else
            @results_vacancy = Company::Vacancy.admin_vacancy_init_list(keyword).where(query_with_current_role("companies", "vacancy_search"))
          end
        @results_vacancy = Kaminari.paginate_array(@results_vacancy).page(params[:page]).per(12)
      end
    
      def search_vacancy_detail
        @company_vacancy_list = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name')
        .joins(:m_industries,:m_occupations).where(id: params[:id]).take
      end

      def vacancy_applied_student_list 
        apply_status_query = ""
        apply_status_query = params[:apply_status].blank? ? params[:apply_status] = [] : "vacancy_apply_favourites.apply_status = #{params[:apply_status]}"  
        @company_vacancy_list = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name')
                                                .joins(:m_industries,:m_occupations).where(id: params[:id]).take
        @vacancy_applied_student_list = Company::Vacancy.new.admin_get_applied_list(@company_vacancy_list.id,[apply_status_query])  
        @vacancy_applied_student_list = Kaminari.paginate_array(@vacancy_applied_student_list).page(params[:page]).per(12)
      end
end