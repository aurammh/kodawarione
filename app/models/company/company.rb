class Company::Company < ApplicationRecord
    #belongs_to :user , foreign_key: "user_id",optional: true
    belongs_to :m_industries, class_name: "MIndustry", foreign_key: "m_industry_id",optional: true
    belongs_to :m_regions, class_name: "MRegion", foreign_key: "m_region_id",optional: true
    belongs_to :m_prefectures, class_name: "MPrefecture", foreign_key: "m_prefecture_id",optional: true
    belongs_to :partners, class_name: "Partner::Partner", foreign_key: "partner_id"
    has_many :apply_favourite_transictions, class_name: "ApplyFavouriteTransiction", foreign_key: "company_id"
    has_many :vacancy_apply_favourites, class_name: "VacancyApplyFavourite", foreign_key: "company_id"
    has_many :company_vacancies, class_name: "Company::Vacancy"
    has_many :events, -> { where "event_type = 1" }, class_name: "Event", foreign_key: "created_by_id"
    has_many :activities, class_name: "Company::Activity", foreign_key: "company_id"
    has_many :admin_event_participants, class_name: "Admin::EventParticipant", foreign_key: "admin_event_id"
    has_one_attached :image
    has_one_attached :cover_photo
    has_rich_text :job_info
    has_rich_text :company_intro
    has_rich_text :company_message
    has_rich_text :other_message
    has_rich_text :experience_requirements
    has_rich_text :fresher_requirements
    has_rich_text :fresher_second_requirements
    has_rich_text :company_vision_mission
    has_rich_text :what_we_do
    has_rich_text :how_we_do
    has_rich_text :about_our_team
    has_rich_text :member_message
    has_one :assessment, class_name: "Company::Assessment", foreign_key: "company_id", dependent: :destroy
    has_many :admin_event_participants, class_name: "Admin::EventParticipant", foreign_key: "company_id"
    has_one :interview_stories, class_name: "Company::InterviewStory", foreign_key: "company_id", dependent: :destroy
    after_save :progress_calculation
    self.table_name = "companies"
    include ProgressHelper

    #    # for get/set number inputs
    attr_accessor :capital_amount_string, :sales_amount_string, :prefecture_name,:region_name, :not_company_edit, :home_edit, :about_us_edit, :image_data, :employee_count_string

     # 管理者関連
     scope :find_by_date, -> (startDate, endDate){ select('date(created_at) AS created_at,count(id) AS companycount').where("date(created_at) >= '#{startDate}' and date(created_at) <= '#{endDate}' AND delete_flg = 'false'").group("date(created_at)") }
     
     scope :com_find_by_spu_with_date, -> (startDate, endDate, superPartnerIdParam){ select('date(created_at) AS created_at,count(companies.id) AS companycount')
        .where("companies.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}') AND date(created_at) >= '#{startDate}' and date(created_at) <= '#{endDate}' AND delete_flg = 'false'")
        .group("date(created_at)") }
    # ====================================================
    #          Search Company Information by Admin
    # ====================================================
    columnName = ["company_name","prefecture_name","industry_name","(CASE WHEN company_name_kana IS NULL THEN '本登録未完了' ELSE '本登録完了' END)","(CASE WHEN companies.id in (Select distinct company_id from company_vacancies) THEN 'あり' ELSE 'なし' END)","(CASE WHEN companies.id in (Select distinct company_id from company_events) THEN 'あり' ELSE 'なし' END)"]
    scope :admin_search_by_between_two_date, ->(startDate, endDate, keyword){
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name, m_regions.region_name as region')
        .joins(:partners)
        .where(       
            "date(companies.created_at) >= '#{startDate}' AND date(companies.created_at) <= '#{endDate}' AND companies.delete_flg = 'false'" + keyword_search)
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }

    scope :admin_search_by_only_start_date, ->(startDate, keyword){
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name , m_regions.region_name as region')
        .joins(:partners)
        .where(       
            "date(companies.created_at) >= '#{startDate}' AND companies.delete_flg = 'false'" +keyword_search)
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }

     scope :admin_search_by_only_end_date, ->(endDate, keyword){
         keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name , m_regions.region_name as region')
        .joins(:partners)
        .where(
            "date(companies.created_at) <= '#{endDate}' AND companies.delete_flg = 'false'" +keyword_search)
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }

    scope :admin_company_all_init_list, ->(keyword){
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name, m_regions.region_name as region')
        .joins(:partners)
        .where(       
            " companies.delete_flg = 'false'" +keyword_search)
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }

    scope :spu_company_all_init_list, ->(keyword, superPartnerIdParam){
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name, m_regions.region_name as region')
        .where(       
            "companies.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}') AND companies.delete_flg = 'false'" + keyword_search)
        .joins("INNER JOIN partners on companies.partner_id = partners.id LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }
    
    scope :company_all_init_list_for_super_partner, ->(super_partner_id){
        select('companies.*')
        .where(       
            "companies.partner_id in (select id from partners where partners.super_partner_id = '#{super_partner_id}') AND companies.delete_flg = 'false'")
        .joins("INNER JOIN partners on companies.partner_id = partners.id")
        .order("created_at DESC")
        }

    scope :company_all_list_for_partner, ->(partner_id){
        select('companies.*')
        .where(       
            "companies.delete_flg = 'false' and companies.partner_id = #{partner_id} ")
        .joins("INNER JOIN partners on companies.partner_id = partners.id")
        .order("created_at DESC")
        }
    
    scope :spu_search_by_between_two_date, ->(startDate, endDate, superPartnerIdParam, keyword){
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name, m_regions.region_name as region')
        .where(       
            "companies.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}') AND date(companies.created_at) >= '#{startDate}' AND date(companies.created_at) <= '#{endDate}' AND companies.delete_flg = 'false'" + keyword_search)
        .joins("INNER JOIN partners on companies.partner_id = partners.id LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }
    scope :spu_search_by_only_start_date, ->(startDate, superPartnerIdParam, keyword){
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name , m_regions.region_name as region')
        .where(       
            "companies.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}') AND date(companies.created_at) >= '#{startDate}' AND companies.delete_flg = 'false'" +keyword_search)
        .joins("INNER JOIN partners on companies.partner_id = partners.id LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }

        scope :spu_search_by_only_end_date, ->(endDate, superPartnerIdParam, keyword){
            keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name , m_regions.region_name as region')
        .where(
            "companies.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}') AND date(companies.created_at) <= '#{endDate}' AND companies.delete_flg = 'false'" +keyword_search)
        .joins("INNER JOIN partners on companies.partner_id = partners.id LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }
    
    # ============================================================================================
    #               Search by Company name and keyword in company setting 
    # ============================================================================================
    scope :admin_setting_company_all_init_list, ->(name, keyword){
        columnNames = ["company_name","contact_email","(CASE WHEN company_name_kana IS NULL THEN '本登録未完了' ELSE '本登録完了' END)"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnNames.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        name_search = name.nil? ? '' : " AND lower(companies.company_name) LIKE lower('%#{name}%')"
        select('companies.*')
        .where(       
            " companies.delete_flg = 'false'" +keyword_search + name_search)
        .order("companies.created_at DESC")
        }

    scope :partner_setting_company_all_init_list, ->(name, keyword, partner_id){
        columnNames = ["company_name","contact_email","(CASE WHEN company_name_kana IS NULL THEN '本登録未完了' ELSE '本登録完了' END)"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnNames.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        name_search = name.nil? ? '' : " AND lower(companies.company_name) LIKE lower('%#{name}%')"
        select('companies.*')
        .where(       
            " companies.delete_flg = 'false' and companies.partner_id = #{partner_id}" +keyword_search + name_search)
        .order("companies.created_at DESC")
        }

    scope :super_partner_setting_company_all_init_list, ->(superPartnerIdParam, name, keyword){
        columnNames = ["company_name","contact_email","(CASE WHEN company_name_kana IS NULL THEN '本登録未完了' ELSE '本登録完了' END)"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        name_search = name.nil? ? '' : " AND lower(companies.company_name) LIKE lower('%#{name}%')"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name, m_regions.region_name as region')
        .where(       
            "companies.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}') AND companies.delete_flg = 'false'" + keyword_search + name_search)
        .joins("INNER JOIN partners on companies.partner_id = partners.id LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }

        

    # ====================================================
    #          Search Company Information by Partner
    # ====================================================
    scope :partner_search_by_between_two_date, ->(startDate, endDate, com_partner_id, keyword){
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name, m_regions.region_name as region')
        .where(       
            "date(companies.created_at) >= '#{startDate}' AND date(companies.created_at) <= '#{endDate}' AND companies.delete_flg = 'false' and companies.partner_id = #{com_partner_id} " + keyword_search)
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }

    scope :partner_search_by_only_start_date, ->(startDate, com_partner_id, keyword){
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name , m_regions.region_name as region')
        .where(       
            "date(companies.created_at) >= '#{startDate}' AND companies.delete_flg = 'false' and companies.partner_id = #{com_partner_id} " +keyword_search)
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }

    scope :partner_search_by_only_end_date, ->(endDate, com_partner_id, keyword){
         keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name , m_regions.region_name as region')
        .where(
            "date(companies.created_at) <= '#{endDate}' AND companies.delete_flg = 'false' and companies.partner_id = #{com_partner_id} " +keyword_search)
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }

    scope :partner_company_all_init_list, ->(com_partner_id, keyword){
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('companies.*,m_industries.industry_name, m_prefectures.prefecture_name as pre_name, m_regions.region_name as region')
        .where(       
            " companies.delete_flg = 'false' and companies.partner_id = #{com_partner_id} " +keyword_search)
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = companies.m_prefecture_id LEFT JOIN m_industries on m_industries.id = companies.m_industry_id LEFT JOIN m_regions on m_regions.id = m_prefectures.m_region_id")
        .order("created_at DESC")
        }
    #mail_setting enum
    enum mail_settings: {  unsent: 0, all_in_one: 1, five_in_one: 5, ten_in_one: 10 }
    validates :company_name, length: { maximum: 255 }, presence: true ,on: :update
    validates :company_name_kana, length: { maximum: 255 }, presence: true ,on: :update
    validates :website_url, presence: true, :format => { :with => VALID_URL_REGEX, message: "がフォーマット正しくありません。" }, length: { maximum: 255 }, on: :update
    validates :phone_no, presence: true, length: { within: 6..20 }, on: :update
    validates :m_industry_id, length: { maximum: 8 }, presence: true, on: :update, if: :skip_validation
    validates :company_intro, length: { maximum: 3000 }, on: :update, if: :skip_validation
    validates :address, length: { maximum: 255 }, presence: true, on: :update
    # validates :capital_amount, numericality: { only_integer: true }, on: :update, if: :skip_com_edit_validation
    # validates :sales_amount, numericality: { only_integer: true }, on: :update, if: :skip_com_edit_validation
    validates :related_company, length: { maximum: 1000 }, on: :update, if: :skip_com_edit_validation
    validates :main_bank, length: { maximum: 1000 }, on: :update, if: :skip_com_edit_validation
    validates :basic_idea, length: { maximum: 1000 }, on: :update, if: :skip_com_edit_validation
    validates :contact, length: { maximum: 1000 }, presence: true, on: :update, if: :skip_com_edit_validation
    validates :job_info, length: { maximum: 3000 }, presence: true, on: :update, if: :skip_validation
    validates :history, length: { maximum: 1000 }, on: :update, if: :skip_validation
    validates :company_established, length: { maximum: 60 }, presence: true, on: :update, if: :skip_com_edit_validation
    validates :employee_count_string, length: { maximum: 16 }, presence: true, on: :update, if: :skip_validation
    validates :representative, length: { maximum: 255 }, presence: true, on: :update, if: :skip_com_edit_validation
    validates :postal_code, presence: true, on: :update, if: :postal_code_changed?
    validates :region_name, presence: true, on: :update, if: :postal_code_changed?
    validates :prefecture_name, presence: true, on: :update, if: :postal_code_changed?
    validates :postalcode_city, presence: true, on: :update, if: :postal_code_changed?
    validates :m_prefecture_id, presence: true, on: :update
    validates :company_message, length: { maximum: 3000 }, on: :update, presence: true,if: :about_us_skip_validation
    validates :other_message, length: { maximum: 3000 }, on: :update, presence: true,if: :about_us_skip_validation
    validates :company_vision_mission, length: { maximum: 3000 }, on: :update
    validates :what_we_do, length: { maximum: 3000 }, on: :update
    validates :how_we_do, length: { maximum: 3000 }, on: :update
    validates :about_our_team, length: { maximum: 3000 }, on: :update
    validates :member_message, length: { maximum: 3000 }, on: :update
    validates :experience_requirements, length: { maximum: 3000 }, on: :update
    validates :fresher_requirements, length: { maximum: 3000 }, on: :update
    validates :fresher_second_requirements, length: { maximum: 3000 }, on: :update
    validate  :image_check

    # before_validation(on: :update) do
    #     self.capital_amount = commaSperatorValidation(self.capital_amount_string)
    #     self.sales_amount = commaSperatorValidation(self.sales_amount_string)
    # end
    before_validation(on: [:create, :update]) do
        self.employee_count =  self.employee_count_string.tap { |s| s.delete!(',') }.to_i unless self.employee_count_string.nil?
    end

    #Progress
    def progress_calculation
        company_progress(self)
    end
    
    def commaSperatorValidation(val)
        if val.to_s.strip.empty?
            return val
        else
            return val.tap { |s| s.delete!(',') }.to_i
        end
    end

    # To retrive student's info
    def search_student(parms1,params2)
        parms1 = parms1.delete_if { |a| a.empty? }
        parms2 = params2.delete_if { |a| a.empty? }
        param1 = parms1.join(" AND ")
        param2 = parms2.join(" AND ")
        @results = Student::Student.select('students.*')
        unless param2.nil?
            @results = @results.where(param2)
        end
        unless param1.nil?
            @results = @results.where(param1)
        end
        @results.to_a
    end

    # To retrive student's info for Company
    def search_company_student(parms1,params2)
        parms1 = parms1.delete_if { |a| a.empty? }
        parms2 = params2.delete_if { |a| a.empty? }
        param1 = parms1.join(" AND ")
        param2 = parms2.join(" AND ")
        @results = Student::Student.select('students.*')
                    .joins(" LEFT JOIN student_commitment_abilities ON student_commitment_abilities.student_id = students.id AND student_commitment_abilities.status = 'active'")
                    .joins("LEFT JOIN student_commitment_ability_details on student_commitment_ability_details.student_commitment_ability_id = student_commitment_abilities.id")
                    .group("students.id,students.user_id")
        unless param2.nil?
            @results = @results.where(param2)
        end
        unless param1.nil?
            @results = @results.where(param1)
        end
        @results.to_a
    end

    #for show created vacancy list
    def get_vacancy_list(company_id)
        vacancy_list = Company::Vacancy.select('company_vacancies.*, company_vacancies.id, count(student_id) as apply_count,industry_name,occupation_name')
        .joins(:m_industries,:m_occupations).left_outer_joins(:vacancy_apply_favourites).where("company_vacancies.company_id= ? and company_vacancies.delete_flg = ?", company_id, false)
        .group("company_vacancies.id,company_vacancies.created_at,industry_name,occupation_name").order(created_at: :desc)
        return vacancy_list
    end

    # for scout mail vacancy list
    def get_scout_vacancy_list(company_id,student_id)
        scout_vacancy_list = Company::Vacancy.select('company_vacancies.*, company_vacancies.id, count(student_id) as apply_count,industry_name,occupation_name')
        .joins(:m_industries,:m_occupations).left_outer_joins(:vacancy_apply_favourites)
        .where("NOT EXISTS (SELECT vacancy_id FROM communications WHERE communications.user_id = #{student_id} AND communications.vacancy_id = company_vacancies.id )")
        .where("company_vacancies.company_id= ? and company_vacancies.published_flg = ? and company_vacancies.delete_flg = ?", company_id, true, false)
        .group("company_vacancies.id,company_vacancies.created_at,industry_name,occupation_name").order(created_at: :desc)
        return scout_vacancy_list
    end

    #company scouted result list
    def get_scouted_result(company_id,parms)  
        parms = parms.delete_if { |a| a.empty? }
        param = parms.join(" AND ")
        scouted_result = Student::Student.select("students.*,communications.scout_date,communications.scout_status,communications.id as communication_id,company_vacancies.vacancy_title") 
                                        .joins("INNER JOIN communications ON communications.user_id = students.id") 
                                        .joins(" INNER JOIN company_vacancies ON company_vacancies.id = communications.vacancy_id") 
                                        .where("communications.company_id = ? and company_vacancies.delete_flg = ? and students.delete_flg = ?",  company_id ,false, false) 
                                        .order("communications.scout_date DESC")
        unless param.nil?
            scouted_result = scouted_result.where(param)
        end 
    end

    def get_scouted_result_count(company_id)
        @scouted_result = Student::Student.select("students.*,communications.scout_date,communications.scout_status,company_vacancies.vacancy_title") 
                                            .joins("INNER JOIN communications ON communications.user_id = students.id") 
                                            .joins(" INNER JOIN company_vacancies ON company_vacancies.id = communications.vacancy_id") 
                                            .where("communications.company_id = ? and company_vacancies.delete_flg = ? and students.delete_flg = ?",  company_id ,false, false) 
                                            .order("communications.scout_date DESC")
    end

    #for dashboard & multiple communication student favourite list
    def get_favourite_list(company_id)
        favourite_list =  Student::Student.select("students.*,apply_favourite_transictions.com_std_favourite")
        .joins(:apply_favourite_transictions)
        .where("apply_favourite_transictions.com_std_favourite = ? and apply_favourite_transictions.company_id = ? and students.delete_flg = ?", true, company_id, false)
        .order("students.nick_name")
        return favourite_list
    end 

    #Applied Job Approval List
    def get_applied_job_approval_list(company_id,parms)
        parms = parms.delete_if { |a| a.empty? }
        param = parms.join(" AND ")
        applied_job_approval_list =  Student::Student.select("students.*,vacancy_apply_favourites.company_vacancy_id,vacancy_apply_favourites.apply_flg,vacancy_apply_favourites.apply_date,vacancy_apply_favourites.apply_status,company_vacancies.vacancy_title")
                                                    .joins(:vacancy_apply_favourites)
                                                    .joins(" LEFT JOIN company_vacancies ON company_vacancies.id = vacancy_apply_favourites.company_vacancy_id ")
                                                    .where("vacancy_apply_favourites.apply_flg = ? and vacancy_apply_favourites.company_id = ? and students.delete_flg = ?", true, company_id, false)
                                                    .order("vacancy_apply_favourites.apply_date DESC")
        unless param.nil?
            applied_job_approval_list = applied_job_approval_list.where(param)
        end  
    end

    def get_applied_job_approval_list_count(company_id) 
        applied_job_approval_list =  Student::Student.select("students.*,vacancy_apply_favourites.company_vacancy_id,vacancy_apply_favourites.apply_flg,vacancy_apply_favourites.apply_date,vacancy_apply_favourites.apply_status,company_vacancies.vacancy_title")
                                                    .joins(:vacancy_apply_favourites)
                                                    .joins(" LEFT JOIN company_vacancies ON company_vacancies.id = vacancy_apply_favourites.company_vacancy_id ")
                                                    .where("vacancy_apply_favourites.apply_flg = ? and vacancy_apply_favourites.company_id = ? and students.delete_flg = ?", true, company_id, false)
                                                    .order("students.nick_name") 
    end
    #select event list
    def get_event_entry_list(company_id)
        paramVal = " AND CURRENT_DATE <= events.event_end_date AND events.created_by_id = #{company_id} AND events.event_type = 1 "
        # 1: 新着、2：募集中、3：満員、4：終了
        event_list = Event.select("join_count,events.*,
            CASE WHEN Current_date <= events.application_deadline THEN 
            CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
            ELSE 
                CASE WHEN CURRENT_DATE >= events.post_start_date THEN '1'
                ELSE '2'
                END	
            END
            ELSE '4' END AS status")
        .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
        .where("events.delete_flg = false #{paramVal}")
        .order(status: :ASC,event_start_date: :DESC)
        return event_list
    end

    #get student count who are join event
    def get_join_event_student_count(company_id)
        join_event_count = Event.select('events.*, events.id,count(apply_favourite_transictions.student_id) as join_count')
        .joins(:apply_favourite_transictions)
        .where("apply_favourite_transictions.event_join= ? and events.created_by_id= ? and events.delete_flg = ? and events.event_type = ? ",true, company_id, false,1)
        .group("events.id,events.created_at").order(created_at: :desc)
        return join_event_count
    end

    # get student list who are join event
    def get_joined_event_student_list(event_id)
        join_event_list = Student::Student.select('students.*,student_commitment_abilities.status ')
        .joins(:apply_favourite_transictions)
        .joins("FULL OUTER JOIN student_commitment_abilities ON student_commitment_abilities.student_id = students.id AND student_commitment_abilities.status = 'active'")
        .where("apply_favourite_transictions.event_join= ? and apply_favourite_transictions.event_id= ?",true, event_id)
        return join_event_list
    end

    # get Top3 Favourite Company
    def show_top_3_fav_company()
        Company::Company.select("count(apply_favourite_transictions.company_id) AS fav_count,companies.company_name,apply_favourite_transictions.company_id,companies.partner_id")
        .joins(:apply_favourite_transictions)
        .where("date(apply_favourite_transictions.created_at) >= '#{Date.today.at_beginning_of_month.strftime('%Y-%m-%d')}' and date(apply_favourite_transictions.created_at) <= '#{Date.today.end_of_month.strftime('%Y-%m-%d')}' and apply_favourite_transictions.std_com_favourite = true AND companies.delete_flg = 'false'")
        .group("apply_favourite_transictions.company_id,companies.company_name,companies.partner_id")
        .order("count(apply_favourite_transictions.company_id) DESC,companies.company_name")
    end

    # search event those admin created
    def self.admin_event_search_by_association(param)
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        Admin::Event.where("CURRENT_DATE BETWEEN admin_events.post_start_date AND admin_events.post_end_date AND admin_events.delete_flg = false #{param == "" ? param : 'AND '+ param}").order(application_deadline: :asc).to_a
    end

    # get Company Count By Industry
    def get_company_count_by_industry()
        Company::Company.select("COALESCE( NULLIF(m_industries.industry_name,'') ,'未選択') AS industry, count(companies.id)")
        .left_joins(:m_industries)
        .where("companies.delete_flg = 'false'")
        .group('m_industries.id,m_industries.industry_name')
        .order('m_industries.id')
    end

    #get company count by delete
    def get_company_count_by_delete()
        Company::Company.select("(companies.delete_flg) AS delete_com, count(companies.id)")
        .group('companies.delete_flg')
    end

    #get company count by postalcode_city
    def get_company_count_by_postalcode_city()
        Company::Company.select("COALESCE( NULLIF(companies.postalcode_city,'') ,'未選択') AS city, count(companies.id)")
        .where("companies.delete_flg = 'false'")
        .group('companies.postalcode_city')
    end

    # get Company Count By Region for suepr partner
    def get_company_count_by_region()
        Company::Company.select("COALESCE( NULLIF(m_prefectures.prefecture_name,'') ,'未選択') AS prefecture, count(companies.id)")
        .joins("LEFT JOIN m_prefectures ON m_prefectures.id = companies.m_prefecture_id")
        .where("companies.delete_flg = 'false'")
        .group('m_prefectures.id, m_prefectures.prefecture_name')
        .order('m_prefectures.id')
    end

    # get Company Count By Region for suepr partner
    def get_company_count_by_region_for_super_partner(super_partner_id)
        Company::Company.select("COALESCE( NULLIF(m_prefectures.prefecture_name,'') ,'未選択') AS prefecture, count(companies.id)")
        .joins("LEFT JOIN m_prefectures ON m_prefectures.id = companies.m_prefecture_id INNER JOIN partners on companies.partner_id = partners.id")
        .where("companies.partner_id in (select id from partners where partners.super_partner_id = '#{super_partner_id}') AND companies.delete_flg = 'false'")
        .group('m_prefectures.id, m_prefectures.prefecture_name')
        .order('m_prefectures.id')
    end

    # get Company Count By Region for partner
    def get_company_count_by_region_for_partner(partner_id)
        Company::Company.select("COALESCE( NULLIF(m_prefectures.prefecture_name,'') ,'未選択') AS prefecture, count(companies.id)")
        .joins(" LEFT JOIN m_prefectures ON m_prefectures.id = companies.m_prefecture_id")
        .where("companies.delete_flg = 'false' and companies.partner_id = #{partner_id}")
        .group('m_prefectures.id, m_prefectures.prefecture_name')
        .order('m_prefectures.id')
    end

    # Get Company Count by Employee Count
    def get_company_count_by_employee_count()
        Company::Company.select("count(companies.id),
        CASE
            WHEN companies.employee_count >= 1 and companies.employee_count <= 20 THEN '1-20'
            WHEN companies.employee_count >= 21 and companies.employee_count <= 50 THEN '21-50'
            WHEN companies.employee_count >= 51 and companies.employee_count <= 100 THEN '51-100'
            WHEN companies.employee_count >= 101 and companies.employee_count <= 200 THEN '101-200'
            WHEN companies.employee_count >= 201 THEN '201-above'
            WHEN companies.employee_count isnull then '未入力'
        END as status
        ")
        .where("companies.delete_flg = 'false'")
	    .group('status')
    end

    def get_company_count_by_employee_count_for_partner(partner_id)
        Company::Company.select("count(companies.id),
        CASE
            WHEN companies.employee_count >= 1 and companies.employee_count <= 20 THEN '1-20'
            WHEN companies.employee_count >= 21 and companies.employee_count <= 50 THEN '21-50'
            WHEN companies.employee_count >= 51 and companies.employee_count <= 100 THEN '51-100'
            WHEN companies.employee_count >= 101 and companies.employee_count <= 200 THEN '101-200'
            WHEN companies.employee_count >= 201 THEN '201-above'
            WHEN companies.employee_count isnull then '未入力'
        END as status
        ")
        .where("companies.delete_flg = 'false' and companies.partner_id = #{partner_id}")
	    .group('status')
    end

    def get_company_count_by_employee_count_for_super_partner(super_partner_id)
        Company::Company.select("count(companies.id),
        CASE
            WHEN companies.employee_count >= 1 and companies.employee_count <= 20 THEN '1-20'
            WHEN companies.employee_count >= 21 and companies.employee_count <= 50 THEN '21-50'
            WHEN companies.employee_count >= 51 and companies.employee_count <= 100 THEN '51-100'
            WHEN companies.employee_count >= 101 and companies.employee_count <= 200 THEN '101-200'
            WHEN companies.employee_count >= 201 THEN '201-above'
            WHEN companies.employee_count isnull then '未入力'
        END as status
        ")
        .joins("INNER JOIN partners on companies.partner_id = partners.id")
        .where("companies.partner_id in (select id from partners where partners.super_partner_id = '#{super_partner_id}') AND companies.delete_flg = 'false'")
	    .group('status')        
    end

    def get_company_count_by_employee_count_for_dashboard
        Company::Company.find_by_sql("
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '1人 - 20 人' AS status, 2 AS count_order
        FROM companies
        WHERE companies.delete_flg = 'false' AND companies.employee_count >= 1 and companies.employee_count <= 20)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '21人 - 50人' AS status, 3 AS count_order
        FROM companies
        WHERE companies.delete_flg = 'false' AND companies.employee_count >= 21 and companies.employee_count <= 50)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '51人 - 100人' AS status, 4 AS count_order
        FROM companies
        WHERE companies.delete_flg = 'false' AND companies.employee_count >= 51 and companies.employee_count <= 100)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '101人 - 200人' AS status, 5 AS count_order
        FROM companies
        WHERE companies.delete_flg = 'false' AND companies.employee_count >= 101 and companies.employee_count <= 200)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '201人 - その上' AS status, 6 AS count_order
        FROM companies
        WHERE companies.delete_flg = 'false' AND companies.employee_count > 200)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '未入力' AS status, 1 AS count_order
        FROM companies
        WHERE companies.delete_flg = 'false' AND companies.employee_count IS NULL)
        ORDER BY count_order DESC
        ")
    end

    def get_company_count_by_employee_count_for_super_partner_dashboard(super_partner_id)
        Company::Company.find_by_sql("
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '1人 - 20人' AS status, 2 AS count_order
        FROM companies
        INNER JOIN partners on companies.partner_id = partners.id
        WHERE companies.partner_id in (select id from partners where partners.super_partner_id = '#{super_partner_id}') AND companies.delete_flg = 'false' AND companies.employee_count >= 1 and companies.employee_count <= 20)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '21人 - 50人' AS status, 3 AS count_order
        FROM companies
        INNER JOIN partners on companies.partner_id = partners.id
        WHERE companies.partner_id in (select id from partners where partners.super_partner_id = '#{super_partner_id}') AND companies.delete_flg = 'false' AND companies.employee_count >= 21 and companies.employee_count <= 50)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '51人 - 100人' AS status, 4 AS count_order
        FROM companies
        INNER JOIN partners on companies.partner_id = partners.id
        WHERE companies.partner_id in (select id from partners where partners.super_partner_id = '#{super_partner_id}') AND companies.delete_flg = 'false' AND companies.employee_count >= 51 and companies.employee_count <= 100)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '101人 - 200人' AS status, 5 AS count_order
        FROM companies
        INNER JOIN partners on companies.partner_id = partners.id
        WHERE companies.partner_id in (select id from partners where partners.super_partner_id = '#{super_partner_id}') AND companies.delete_flg = 'false' AND companies.employee_count >= 101 and companies.employee_count <= 200)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '201人 - その上' AS status, 6 AS count_order
        FROM companies
        INNER JOIN partners on companies.partner_id = partners.id
        WHERE companies.partner_id in (select id from partners where partners.super_partner_id = '#{super_partner_id}') AND companies.delete_flg = 'false' AND companies.employee_count > 200)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '未入力' AS status, 1 AS count_order
        FROM companies
        INNER JOIN partners on companies.partner_id = partners.id
        WHERE companies.partner_id in (select id from partners where partners.super_partner_id = '#{super_partner_id}') AND companies.delete_flg = 'false' AND companies.employee_count IS NULL)
        ")
    end

    def get_company_count_by_employee_count_for_partner_dashboard(partner_id)
        Company::Company.find_by_sql("
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '1人 - 20人' AS status, 2 AS count_order
        FROM companies
        WHERE companies.partner_id = #{partner_id} AND companies.delete_flg = 'false' AND companies.employee_count >= 1 and companies.employee_count <= 20)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '21人 - 50人' AS status, 3 AS count_order
        FROM companies
        WHERE companies.partner_id = #{partner_id} AND companies.delete_flg = 'false' AND companies.employee_count >= 21 and companies.employee_count <= 50)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '51人 - 100人' AS status, 4 AS count_order
        FROM companies
        WHERE companies.partner_id = #{partner_id} AND companies.delete_flg = 'false' AND companies.employee_count >= 51 and companies.employee_count <= 100)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '101人 - 200人' AS status, 5 AS count_order
        FROM companies
        WHERE companies.partner_id = #{partner_id} AND companies.delete_flg = 'false' AND companies.employee_count >= 101 and companies.employee_count <= 200)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '201人 - その上' AS status, 6 AS count_order
        FROM companies
        WHERE companies.partner_id = #{partner_id} AND companies.delete_flg = 'false' AND companies.employee_count > 200)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '未入力' AS status, 1 AS count_order
        FROM companies
        WHERE companies.partner_id = #{partner_id} AND companies.delete_flg = 'false' AND companies.employee_count IS NULL)
        ")
    end
       
    # .where("companies.delete_flg = 'false' and companies.partner_id = #{partner_id}")
    def get_company_count_by_employee_count_for_partner_details(partner_id)
        Company::Company.find_by_sql("(SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '1人 - 20人' AS status, 2 AS count_order
        FROM companies
        WHERE companies.delete_flg = 'false' AND companies.partner_id = #{partner_id} AND companies.employee_count >= 1 and companies.employee_count <= 20)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '21人 - 50人' AS status, 3 AS count_order
        FROM companies
        WHERE companies.delete_flg = 'false' AND companies.partner_id = #{partner_id} AND  companies.employee_count >= 21 and companies.employee_count <= 50)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '51人 - 100人' AS status, 4 AS count_order
        FROM companies
        WHERE companies.delete_flg = 'false' AND companies.partner_id = #{partner_id} AND  companies.employee_count >= 51 and companies.employee_count <= 100)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '101人 - 200人' AS status, 5 AS count_order
        FROM companies
        WHERE companies.delete_flg = 'false' AND companies.partner_id = #{partner_id} AND  companies.employee_count >= 101 and companies.employee_count <= 200)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '201人 - その上' AS status, 6 AS count_order
        FROM companies
        WHERE companies.delete_flg = 'false' AND companies.partner_id = #{partner_id} AND  companies.employee_count > 200)
        UNION ALL
        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
        END, '未入力' AS status, 1 AS count_order
        FROM companies
        WHERE companies.delete_flg = 'false' AND companies.partner_id = #{partner_id} AND  companies.employee_count IS NULL)   
        ORDER BY count_order DESC     
        ")
    end

    def get_company_count_by_employee_count_for_super_partner_details(super_partner_id)
        Company::Company.find_by_sql("(SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
                        END, '1人 - 20人' as status, 2 as count_order
                        FROM companies
                        INNER JOIN partners on companies.partner_id = partners.id 
		                WHERE (companies.partner_id in (select id from partners where partners.super_partner_id = #{super_partner_id}) 
				        AND companies.delete_flg = 'false' AND companies.employee_count >= 1 and companies.employee_count <= 20))
                        Union ALL
                        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
                        END, '21人 - 50人' as status, 3 as count_order
                        FROM companies
                        INNER JOIN partners on companies.partner_id = partners.id 
		                WHERE (companies.partner_id in (select id from partners where partners.super_partner_id = #{super_partner_id}) 
				        AND companies.delete_flg = 'false' AND companies.employee_count >= 21 and companies.employee_count <= 50))
                        Union ALL
                        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
                        END, '51人 - 100人' as status, 4 as count_order
                        FROM companies
                        INNER JOIN partners on companies.partner_id = partners.id 
		                WHERE (companies.partner_id in (select id from partners where partners.super_partner_id = #{super_partner_id}) 
				        AND companies.delete_flg = 'false' AND companies.employee_count >= 51 and companies.employee_count <= 100))
                        Union ALL
                        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
                        END, '101人 - 200人' as status, 5 as count_order
                        FROM companies
                        INNER JOIN partners on companies.partner_id = partners.id 
		                WHERE (companies.partner_id in (select id from partners where partners.super_partner_id = #{super_partner_id}) 
				        AND companies.delete_flg = 'false' AND companies.employee_count >= 101 and companies.employee_count <= 200))
                        Union ALL
                        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
                        END, '201人 - その上' as status, 6 as count_order
                        FROM companies
                        INNER JOIN partners on companies.partner_id = partners.id 
		                WHERE (companies.partner_id in (select id from partners where partners.super_partner_id = #{super_partner_id}) 
				        AND companies.delete_flg = 'false' AND companies.employee_count > 200))
                        Union ALL
                        (SELECT CASE WHEN count(companies.id) is null then 0 else count(companies.id) 
                        END, '未入力' as status, 1 as count_order
                        FROM companies
                        INNER JOIN partners on companies.partner_id = partners.id 
		                WHERE (companies.partner_id in (select id from partners where partners.super_partner_id = #{super_partner_id}) 
				        AND companies.delete_flg = 'false' AND companies.employee_count is NULL))
                        ORDER BY count_order DESC
                        ")
    
    end


    # Company List By Vacancy Creat
    def company_count_by_vacancy_create_by_partner(partner_id)
        Company::Company.select('distinct(companies.id)')
        .joins("INNER JOIN company_vacancies on companies.id = company_vacancies.company_id")
        .where("companies.delete_flg = false and company_vacancies.delete_flg = false and companies.partner_id = #{partner_id}")
    end

    def company_count_by_vacancy_create_by_super_partner(super_partner_id)
        Company::Company.select('distinct(companies.id)')
        .joins("INNER JOIN company_vacancies on companies.id = company_vacancies.company_id INNER JOIN partners on companies.partner_id = partners.id")
        .where("companies.partner_id in (select id from partners where partners.super_partner_id = '#{super_partner_id}') AND companies.delete_flg = false and company_vacancies.delete_flg = false")
    end

    def company_count_by_vacancy_create_by_admin()
        Company::Company.select('distinct(companies.id)')
        .joins("INNER JOIN company_vacancies on companies.id = company_vacancies.company_id")
        .where("companies.delete_flg = false and company_vacancies.delete_flg = false")
      end

    private

    def skip_com_edit_validation
        not_company_edit == "true" ? false : true
    end
    
    def skip_validation
        home_edit == "true" ? true : false
    end

    def about_us_skip_validation
        about_us_edit == "true" ? true : false
    end

    def image_check
        if image_data == "false" && !image.attached?
             errors.add(:image)
        end
    end

end