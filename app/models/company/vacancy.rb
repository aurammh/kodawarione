class Company::Vacancy < ApplicationRecord
    belongs_to :company , class_name: "Company::Company", foreign_key: "company_id"
    belongs_to :m_industries, class_name: "MIndustry", foreign_key: "recruit_industry_type",optional: true
    belongs_to :m_occupations, class_name: "MOccupation", foreign_key: "recruit_job_type",optional: true
    #has_many :apply_favourite_transictions, class_name: "ApplyFavouriteTransiction", foreign_key: "job_id"
    has_many :vacancy_apply_favourites, class_name: "VacancyApplyFavourite", foreign_key: "company_vacancy_id"
    has_rich_text :vacancy_description
    self.table_name = "company_vacancies"
    attr_accessor :prefecture_name,:region_name,:required_applicants_string,:basic_salary_string
    enum company_vacancy_enhancement: { disaster_support: 1, child_care_support: 2, work_env_support: 3, athletics_support: 4, property_support: 5 }

    columnName = ["company_name", "vacancy_title", "industry_name","occupation_name ","working_hours","required_applicants::text"]
    scope :admin_vacancy_search_by_between_two_date, ->(vacancy_startDate, vacancy_endDate, keyword){
      keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
      select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
      .where(       
       "date(company_vacancies.created_at)>= '#{vacancy_startDate}' AND date(company_vacancies.created_at) <= '#{vacancy_endDate}' AND (company_vacancies.delete_flg = 'false') " + keyword_search)
      .joins(:company,:m_industries,:m_occupations)
      .order("created_at DESC")
      }

    scope :admin_vacancy_search_by_start_date, ->(vacancy_startDate, keyword){
      keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
      select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
      .where(       
        "date(company_vacancies.created_at)>= '#{vacancy_startDate}' AND (company_vacancies.delete_flg = 'false') " + keyword_search)
      .joins(:company,:m_industries,:m_occupations)
      .order("created_at DESC")
      }

    scope :admin_vacancy_search_by_only_end_date, ->(vacancy_endDate, keyword){
       keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
       select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
       .where(       
        "date(company_vacancies.created_at) <= '#{vacancy_endDate}' AND (company_vacancies.delete_flg = 'false')" + keyword_search)
       .joins(:company,:m_industries,:m_occupations)
       .order("created_at DESC")
       }

       scope :vacancy_search_by_between_two_date, ->(vacancy_startDate, vacancy_endDate, keyword){
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
        select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
        .where(       
         "date(company_vacancies.display_from)>= '#{vacancy_startDate}' AND date(company_vacancies.display_to)<= '#{vacancy_endDate}' AND (company_vacancies.delete_flg = 'false') " + keyword_search)
        .joins(:company,:m_industries,:m_occupations)
        .order("created_at DESC")
        }

    scope :vacancy_search_by_start_date, ->(vacancy_startDate, keyword){
      keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
      select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
      .where(       
        "date(company_vacancies.display_to)>= '#{vacancy_startDate}' AND (company_vacancies.delete_flg = 'false') " + keyword_search)
      .joins(:company,:m_industries,:m_occupations)
      .order("created_at DESC")
      }
  
    scope :vacancy_search_by_only_end_date, ->(vacancy_endDate, keyword){
      keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
      select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
      .where(       
        "date(company_vacancies.display_from)<= '#{vacancy_endDate}' AND (company_vacancies.delete_flg = 'false')" + keyword_search)
        .joins(:company,:m_industries,:m_occupations)
        .order("created_at DESC")
        }
    
    scope :admin_vacancy_init_list, ->(keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
    .where(       
      " (company_vacancies.delete_flg = 'false')" + keyword_search)
    .joins(:company,:m_industries,:m_occupations)
    .order("created_at DESC")
    }

    # Super Partner User Company Vacancy
    super_partner_vacancy_columnName = ["vacancy_title", "industry_name","occupation_name ","working_hours","required_applicants::text"]
    scope :super_partner_company_vacancy_lists, ->(super_partner_id,keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_vacancy_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
    .where(       
      "companies.partner_id in (select id from partners where partners.super_partner_id = #{super_partner_id}) AND (company_vacancies.delete_flg = 'false')" + keyword_search)
    .joins(:company,:m_industries,:m_occupations)
    .order("created_at DESC")
    }

    scope :super_partner_company_vacancy_search_by_only_end_date, ->(super_partner_id, vacancy_endDate, keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_vacancy_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
    .where(       
    "date(company_vacancies.created_at) <= '#{vacancy_endDate}' AND companies.partner_id in (select id from partners where partners.super_partner_id = #{super_partner_id}) AND (company_vacancies.delete_flg = 'false')" + keyword_search)
    .joins(:company,:m_industries,:m_occupations)
    .order("created_at DESC")
    }

    scope :super_partner_company_vacancy_search_by_start_date, ->(super_partner_id, vacancy_startDate, keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_vacancy_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
    .where(       
      "date(company_vacancies.created_at)>= '#{vacancy_startDate}' AND companies.partner_id in (select id from partners where partners.super_partner_id = #{super_partner_id}) AND (company_vacancies.delete_flg = 'false') " + keyword_search)
    .joins(:company,:m_industries,:m_occupations)
    .order("created_at DESC")
    }

    scope :super_partner_company_vacancy_search_by_between_two_date, ->(super_partner_id, vacancy_startDate, vacancy_endDate, keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_vacancy_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,companies.company_name')
    .where(       
      "date(company_vacancies.created_at)>= '#{vacancy_startDate}' AND date(company_vacancies.created_at) <= '#{vacancy_endDate}' AND companies.partner_id in (select id from partners where partners.super_partner_id = #{super_partner_id}) AND (company_vacancies.delete_flg = 'false') " + keyword_search)
    .joins(:company,:m_industries,:m_occupations)
    .order("created_at DESC")
    }

    scope :left_outer_join_application_status_transactions, -> (student_id){joins("LEFT OUTER JOIN application_status_transactions on application_status_transactions.company_vacancy_id = company_vacancies.id AND application_status_transactions.student_id = #{student_id}")}
    
    validates :vacancy_title, length: {maximum: 255}, presence: true
    validates :vacancy_description,length: {maximum: 3000}, presence: true
    validates :recruit_industry_type,presence: true
    validates :recruit_job_type, presence: true
    validates :address, length: {maximum: 255}, presence: true
    validates :postal_code, length: {is: 7 }, presence: true
    validates :region_name, presence: true
    validates :prefecture_name, presence: true
    validates :postalcode_city, presence: true
    validates :other_skill, length: {maximum: 255}
    validates :allowance, presence: true
    validates :bonus,presence: true 
    validates :required_applicants_string, length: {maximum: 8}, presence: true
    validates :basic_salary_string, length: {maximum: 8}, presence: true
    validates :working_hours, length: {maximum: 255}, presence: true
    validates :break_time, length: {maximum: 255}, presence: true
    validates :holiday, length: {maximum: 255}, presence: true
    validates :display_from, presence: true, on: [:create, :update]
    validates :display_to, presence: true, on: [:create, :update]
    validate :check_display_date

    before_validation(on: [:create, :update]) do
      self.required_applicants =  self.required_applicants_string.tap { |s| s.delete!(',') }.to_i unless self.required_applicants_string.nil? 
      self.basic_salary =  self.basic_salary_string.tap { |s| s.delete!(',') }.to_i unless self.basic_salary_string.nil? 
    end
    
    def check_display_date
      unless display_to.nil?
        if  display_from != nil && display_from > display_to
          errors.add(:display_to)
        end
      end
    end

    def get_applied_list(company_id, company_vacancy_id,parms) 
      parms = parms.delete_if { |a| a.empty? }
      param = parms.join(" AND ") 
      if company_vacancy_id.present? 
        vacancy_id = 'AND vacancy_apply_favourites.company_vacancy_id = ' + company_vacancy_id.to_s
      else 
        vacancy_id =  company_vacancy_id 
      end 
      job_applied_list =  Student::Student.select("students.*,vacancy_apply_favourites.apply_status,vacancy_apply_favourites.company_vacancy_id,company_vacancies.vacancy_title")
                                          .joins(:vacancy_apply_favourites)
                                          .joins(" LEFT JOIN company_vacancies ON company_vacancies.id = vacancy_apply_favourites.company_vacancy_id ")
                                          .where("vacancy_apply_favourites.apply_flg = true #{vacancy_id} AND vacancy_apply_favourites.company_id = ?  AND students.delete_flg = ?" ,company_id, false )
                                          .order("students.nick_name") 
      unless param.nil?
        job_applied_list = job_applied_list.where(param)
      end
 
    end

    def admin_get_applied_list(company_vacancy_id,parms) 
      parms = parms.delete_if { |a| a.empty? }
      param = parms.join(" AND ") 
      if company_vacancy_id.present? 
        vacancy_id = 'AND vacancy_apply_favourites.company_vacancy_id = ' + company_vacancy_id.to_s
      else 
        vacancy_id =  company_vacancy_id 
      end 
      job_applied_list =  Student::Student.select("students.*,vacancy_apply_favourites.apply_status,vacancy_apply_favourites.company_vacancy_id,company_vacancies.vacancy_title")
                                          .joins(:vacancy_apply_favourites)
                                          .joins(" LEFT JOIN company_vacancies ON company_vacancies.id = vacancy_apply_favourites.company_vacancy_id ")
                                          .where("vacancy_apply_favourites.apply_flg = true #{vacancy_id}  AND students.delete_flg = ?", false )
                                          .order("students.nick_name") 
      unless param.nil?
        job_applied_list = job_applied_list.where(param)
      end
 
    end
end