class Student::Student < ApplicationRecord
    belongs_to :user
    has_one :assessment, class_name: "Student::Assessment", foreign_key: "student_id", dependent: :destroy
    has_many :apply_favourite_transictions, class_name: "ApplyFavouriteTransiction", foreign_key: "student_id"
    has_many :vacancy_apply_favourites, class_name: "VacancyApplyFavourite", foreign_key: "student_id"
    belongs_to :m_regions, class_name: "MRegion", foreign_key: "postal_region_id",optional: true
    belongs_to :m_prefectures, class_name: "MPrefecture", foreign_key: "postal_prefecture_id",optional: true
    has_one_attached :image
    has_one_attached :cover_photo
    has_one_attached :attachment_for_pr
    before_save :upcase_fields
    after_save :progress_calculation
    self.table_name = "students"
    include ProgressHelper
    # 管理者関連
    scope :find_by_date, -> (startDate, endDate) { select('date(students.created_at) AS created_at,count(students.id) AS studentcount').where("date(students.created_at) >= '#{startDate}' and date(students.created_at) <= '#{endDate}' AND students.delete_flg = 'false'").group("date(students.created_at)") }

    scope :stu_find_by_spu_with_date, -> (startDate, endDate, superPartnerIdParam) { select('date(students.created_at) AS created_at,count(students.id) AS studentcount')
        .where("students.user_id in(select users.id from users INNER JOIN partners on users.partner_id = partners.id where users.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}')) AND date(students.created_at) >= '#{startDate}' and date(students.created_at) <= '#{endDate}' AND students.delete_flg = 'false'")
        .group("date(students.created_at)") }

    scope :find_by_gender, -> { select('distinct(COALESCE( NULLIF(gender,NULL) ,2)) AS gender_name,count(id) AS studentcount').where("date(created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND delete_flg = 'false'").group('gender_name').order('gender_name') }

    scope :find_by_gender_for_super_partner, ->(super_partner_id) { 
        select('distinct(COALESCE( NULLIF(gender,NULL) ,2)) AS gender_name,count(students.id) AS studentcount')
        .joins("LEFT JOIN users on users.id = students.user_id")
        .where(       
            "students.user_id in(select users.id from users 
            INNER JOIN partners on users.partner_id = partners.id where users.partner_id in (select id from partners where partners.super_partner_id = '#{super_partner_id}')) 
            AND date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND students.delete_flg = 'false' " 
        )
        .group('gender_name')
        .order('gender_name') }

    scope :find_by_gender_partner, -> { select('distinct(COALESCE( NULLIF(students.gender,NULL) ,2)) AS gender_name,count(students.id) AS studentcount').joins(" LEFT JOIN users ON users.id = students.user_id ").where("date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND students.delete_flg = 'false'").group('gender_name').order('gender_name') }
    
    

    columnName = ["school_name","prefecture_name","club_name","(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthday))::text","(CASE WHEN birthday IS NULL THEN '本登録未完了' ELSE '本登録完了' END)","(CASE WHEN students.id in (Select distinct student_id from student_assessments) THEN '実施' ELSE '未実施' END)"]
    scope :admin_search_by_between_two_date, ->(date_type, startDate, endDate, keyword,gender_query,schooltype_query){
       condition_search = date_type.eql?("graduation_date") ? "(to_date(students.#{date_type}::text,'YYYY-MM-DD')+ interval '1 month - 1 day')::date >= '#{startDate}' AND to_date(students.#{date_type}::text,'YYYY-MM-DD') <= '#{endDate}' AND students.delete_flg = 'false'" : "to_date(students.#{date_type}::text,'YYYY-MM-DD') >= '#{startDate}' AND to_date(students.#{date_type}::text,'YYYY-MM-DD') <= '#{endDate}' AND students.delete_flg = 'false'"
       name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword.gsub(/'/, "''") }%'))"
       keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')} #{name_search})"
       gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
       schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
       select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
       .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
       .joins(:user)
       .joins("Left join partners on partners.id = users.partner_id")
       .where(       
           condition_search + keyword_search + gender_search + schooltype_search
       )
       .order("students.#{date_type} DESC")
    }
    
    scope :admin_search_by_only_start_date, ->(date_type, startDate, keyword,gender_query,schooltype_query){
        condition_search = date_type.eql?("graduation_date") ? "(to_date(students.#{date_type}::text,'YYYY-MM-DD')+ interval '1 month - 1 day')::date >= '#{startDate}' AND students.delete_flg = 'false'" : "to_date(students.#{date_type}::text,'YYYY-MM-DD') >= '#{startDate}' AND students.delete_flg = 'false'"
        name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword.gsub(/'/, "''") }%'))"
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')} #{name_search})"
        gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
        schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
        select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
        .joins(:user)
        .joins("Left join partners on partners.id = users.partner_id")    
        .where(       
            condition_search + keyword_search + gender_search + schooltype_search
        )
        .order("students.#{date_type} DESC")
    }

    scope :admin_search_by_only_end_date, ->(date_type, endDate, keyword,gender_query,schooltype_query){
       condition_search = date_type.eql?("graduation_date") ? "(to_date(students.#{date_type}::text,'YYYY-MM-DD')+ interval '1 month - 1 day')::date <= '#{endDate}' AND students.delete_flg = 'false'" : "to_date(students.#{date_type}::text,'YYYY-MM-DD') <= '#{endDate}'AND students.delete_flg = 'false'"      
       name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword.gsub(/'/, "''") }%'))"
       keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')} #{name_search})"
       gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
       schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
       select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
       .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
       .joins(:user)
       .joins("Left join partners on partners.id = users.partner_id")
       .where(       
            condition_search + keyword_search + gender_search + schooltype_search
       )
       .order("students.#{date_type} DESC")
    }

    scope :admin_all_init_list, ->(keyword,gender_query,schooltype_query) {
       name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword.gsub(/'/, "''") }%'))"
       keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')} #{name_search})"
       gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
       schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
       select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
       .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
       .joins(:user)
       .joins("Left join partners on partners.id = users.partner_id")
        .where(       
           "students.delete_flg = 'false' " + keyword_search + gender_search + schooltype_search
       )
       .order("created_at DESC")
    }

    scope :student_all_list_for_super_partner, ->(super_partner_id) {
        select("students.*")
        .joins("LEFT JOIN users on users.id = students.user_id")
         .where(       
            "students.user_id in(select users.id from users INNER JOIN partners on users.partner_id = partners.id where users.partner_id in (select id from partners where partners.super_partner_id = '#{super_partner_id}')) AND students.delete_flg = 'false' "
        )
        .order("created_at DESC")
    }

    scope :student_all_list_for_partner, ->(partner_id) {
        select("students.*")
        .joins("LEFT JOIN users on users.id = students.user_id")
         .where(       
            "students.delete_flg = 'false' AND users.partner_id = '#{partner_id}'"
        )
        .order("created_at DESC")
    }

    scope :spu_all_init_list, ->(keyword,gender_query,schooltype_query,superPartnerIdParam) {
        name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword.gsub(/'/, "''") }%'))"
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')} #{name_search})"
        gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
        schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
        select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
         .where(       
            "students.user_id in(select users.id from users INNER JOIN partners on users.partner_id = partners.id where users.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}')) AND students.delete_flg = 'false' " + keyword_search + gender_search + schooltype_search
        )
        .order("created_at DESC")
     }

     scope :spu_search_by_between_two_date, ->(date_type, startDate, endDate, keyword,gender_query,schooltype_query,superPartnerIdParam){
        condition_search = date_type.eql?("graduation_date") ? "(to_date(students.#{date_type}::text,'YYYY-MM-DD')+ interval '1 month - 1 day')::date >= '#{startDate}' AND to_date(students.#{date_type}::text,'YYYY-MM-DD') <= '#{endDate}' AND students.delete_flg = 'false'" : "to_date(students.#{date_type}::text,'YYYY-MM-DD') >= '#{startDate}' AND to_date(students.#{date_type}::text,'YYYY-MM-DD') <= '#{endDate}' AND students.delete_flg = 'false'"
        name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword.gsub(/'/, "''") }%'))"
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')} #{name_search})"
        gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
        schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
        select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
         .where(       
            "students.user_id in(select users.id from users INNER JOIN partners on users.partner_id = partners.id where users.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}')) AND students.delete_flg = 'false' AND " + condition_search + keyword_search + gender_search + schooltype_search
        )
        .order("students.#{date_type} DESC")
     }
     
     scope :spu_search_by_only_start_date, ->(date_type, startDate, keyword,gender_query,schooltype_query,superPartnerIdParam){
         condition_search = date_type.eql?("graduation_date") ? "(to_date(students.#{date_type}::text,'YYYY-MM-DD')+ interval '1 month - 1 day')::date >= '#{startDate}' AND students.delete_flg = 'false'" : "to_date(students.#{date_type}::text,'YYYY-MM-DD') >= '#{startDate}' AND students.delete_flg = 'false'"
         name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword.gsub(/'/, "''") }%'))"
         keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')} #{name_search})"
         gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
         schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
         select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
         .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
            .where(       
                "students.user_id in(select users.id from users INNER JOIN partners on users.partner_id = partners.id where users.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}')) AND students.delete_flg = 'false' AND " + condition_search + keyword_search + gender_search + schooltype_search
         )
         .order("students.#{date_type} DESC")
     }
 
     scope :spu_search_by_only_end_date, ->(date_type, endDate, keyword,gender_query,schooltype_query,superPartnerIdParam){
        condition_search = date_type.eql?("graduation_date") ? "(to_date(students.#{date_type}::text,'YYYY-MM-DD')+ interval '1 month - 1 day')::date <= '#{endDate}' AND students.delete_flg = 'false'" : "to_date(students.#{date_type}::text,'YYYY-MM-DD') <= '#{endDate}'AND students.delete_flg = 'false'"      
        name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword.gsub(/'/, "''") }%'))"
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')} #{name_search})"
        gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
        schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
        select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
         .where(       
            "students.user_id in(select users.id from users INNER JOIN partners on users.partner_id = partners.id where users.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}')) AND students.delete_flg = 'false' AND " +  condition_search + keyword_search + gender_search + schooltype_search
        )
        .order("students.#{date_type} DESC")
     }

    scope :partner_student_init_list, ->(keyword,gender_query,schooltype_query,partner_id) {
        name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword.gsub(/'/, "''") }%'))"
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')} #{name_search})"
        gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
        schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
        select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
         .where(       
            "students.delete_flg = 'false' AND users.partner_id = '#{partner_id}' " + keyword_search + gender_search + schooltype_search
        )
        .order("created_at DESC")
     }

     scope :partner_stu_search_by_only_end_date, ->(date_type, endDate, keyword,gender_query,schooltype_query,partner_id){
        condition_search = date_type.eql?("graduation_date") ? "(to_date(students.#{date_type}::text,'YYYY-MM-DD')+ interval '1 month - 1 day')::date <= '#{endDate}' AND students.delete_flg = 'false'" : "to_date(students.#{date_type}::text,'YYYY-MM-DD') <= '#{endDate}'AND students.delete_flg = 'false'"      
        name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword.gsub(/'/, "''") }%'))"
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')} #{name_search})"
        gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
        schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
        select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
         .where(       
             "users.partner_id = '#{partner_id}' and " + condition_search + keyword_search + gender_search + schooltype_search
        )
        .order("students.#{date_type} DESC")
     }

    scope :partner_stu_search_by_only_start_date, ->(date_type, startDate, keyword,gender_query,schooltype_query,partner_id){
        condition_search = date_type.eql?("graduation_date") ? "(to_date(students.#{date_type}::text,'YYYY-MM-DD')+ interval '1 month - 1 day')::date >= '#{startDate}' AND students.delete_flg = 'false'" : "to_date(students.#{date_type}::text,'YYYY-MM-DD') >= '#{startDate}' AND students.delete_flg = 'false'"
        name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword.gsub(/'/, "''") }%'))"
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')} #{name_search})"
        gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
        schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
        select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
            .where(       
                "users.partner_id = '#{partner_id}' and " + condition_search + keyword_search + gender_search + schooltype_search
        )
        .order("students.#{date_type} DESC")
        }

    scope :partner_stu_search_by_between_two_date, ->(date_type, startDate, endDate, keyword,gender_query,schooltype_query,partner_id){
        condition_search = date_type.eql?("graduation_date") ? "(to_date(students.#{date_type}::text,'YYYY-MM-DD')+ interval '1 month - 1 day')::date >= '#{startDate}' AND to_date(students.#{date_type}::text,'YYYY-MM-DD') <= '#{endDate}' AND students.delete_flg = 'false'" : "to_date(students.#{date_type}::text,'YYYY-MM-DD') >= '#{startDate}' AND to_date(students.#{date_type}::text,'YYYY-MM-DD') <= '#{endDate}' AND students.delete_flg = 'false'"
        name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword.gsub(/'/, "''") }%'))"
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')} #{name_search})"
        gender_search = gender_query.nil? ? '' : " AND (gender = #{gender_query})"
        schooltype_search = schooltype_query.nil? ? '' : " AND (school_type = #{schooltype_query})"
        select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
        .where(       
        "users.partner_id = '#{partner_id}' and " + condition_search + keyword_search + gender_search + schooltype_search
        )
        .order("students.#{date_type} DESC")
    }
    
    

    # get student list in partner setting and super partner setting
    scope :partner_student_user_setting_list, ->(partner_id, keyword, name) {
        columnNames = ["email","(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthday))::text","(CASE WHEN birthday IS NULL THEN '本登録未完了' ELSE '本登録完了' END)","(CASE WHEN students.id in (Select distinct student_id from student_assessments) THEN '実施' ELSE '未実施' END)"]
        # name_search = name.nil? ? '' : " AND ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{name.gsub(/'/, "''") }%'))"
        name_search = name.nil? ? '' : " AND lower(students.first_name) || lower(students.last_name) LIKE lower('%#{name}%')"
        keyword_search = keyword.nil? ? '' : " AND (#{columnNames.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
         .where(       
            "students.delete_flg = 'false' AND users.partner_id = '#{partner_id}' " + keyword_search + name_search
        )
        .order("created_at DESC")
        }

    scope :super_partner_student_search_setting, ->(superPartnerIdParam, keyword) {
        columnNames = ["email","(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthday))::text","(CASE WHEN birthday IS NULL THEN '本登録未完了' ELSE '本登録完了' END)","(CASE WHEN students.id in (Select distinct student_id from student_assessments) THEN '実施' ELSE '未実施' END)"]
        name_search = keyword.nil? ? '' : " or ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{keyword.gsub(/'/, "''") }%'))"
        keyword_search = keyword.nil? ? '' : " AND (#{columnNames.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')} #{name_search})"
        select("students.*,m_prefectures.prefecture_name as pre_name, m_regions.region_name as region, users.email as main_email")
        .joins("LEFT JOIN m_prefectures on m_prefectures.id = students.postal_prefecture_id LEFT JOIN m_regions on m_regions.id = students.postal_region_id LEFT JOIN users on users.id = students.user_id")
         .where(       
            "students.user_id in(select users.id from users INNER JOIN partners on users.partner_id = partners.id where users.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}')) AND students.delete_flg = 'false' " + keyword_search 
        )
        .order("created_at DESC")
        }

    enum school_type: { university: 1, master_graduate: 2, doctor_graduate: 3, junior_college: 4, techanical_college: 5, national_college: 6, other_university: 7 }
    enum subject_system: { social: 1, science: 2, other_sub: 3 }
    enum outside_activity: { seminar: 1, inside_school_activity: 2, partime: 3, volenteer: 4, major_collage: 5, research:6, trip: 7, hobby: 8, start_up:9, aborad: 10, other_act: 11 }
    enum is_beelab_activity_participate: { beelab_activity_participate: true, not_beelab_activity_participate: false}
    enum gender: { male: 0, female: 1, other_gen: 2}
    enum number_employee: { bet_1_and_5: "1-5", bet_6_and_10: "6-10", bet_11_and_20: "11-20", 
        bet_21_and_50: "21-50", bet_51_and_100: "51-100", bet_101_and_200: "101-200",
        bet_201_and_500: "201-500", bet_501_and_1000: "501-1000", bet_1001_and_5000: "1001-5000", bet_5001_and_10000: "5001-10000", 
        bet_10001_and_20000: "10001-20000", bet_20000_and_more: "20000-20001" }                                     
    validates :last_name, length: { maximum: 100 }, presence: true, if: :stu_edit_validation
    validates :first_name, length: { maximum: 100 }, presence: true, if: :stu_edit_validation
    validates :first_name_kana, length: { maximum: 100 }, presence: true, on: :update, if: :first_name_kana_changed?
    validates :last_name_kana, length: { maximum: 100 }, presence: true, on: :update, if: :last_name_kana_changed?
    validates :birthday, presence: true, on: :update, if: :stu_edit_validation
    validates :nick_name, length: { maximum: 255 },presence: true
    validates :email_two, :format => { :with => VALID_EMAIL_REGEX, message: "がフォーマット正しくありません。" }, :allow_blank => true, length: { maximum: 255 }, on: :update, if: :email_two_changed?
    validates :phone_no, presence: true, length: {within: 6..20 }, on: :update, if: :phone_no_changed?
    validates :address, length: { maximum: 255 }, presence: true, on: :update, if: :address_changed?
    validates :school_type, presence: true, :on => :update, if: :stu_edit_validation
    validates :school_name, length: { maximum: 60 }, presence: true, :on => :update, if: :stu_edit_validation
    validates :department_name, length: { maximum: 60 }, presence: true, :on => :update, if: :stu_edit_validation
    validates :subject_system, presence: true, :on => :update, if: :stu_edit_validation
    validates :graduation_date, presence: true, :on => :update, if: :stu_edit_validation
    validates :postal_code, presence: true, on: :update, if: :postal_code_changed?
    validates :region_name, presence: true, on: :update, if: :postal_code_changed?
    validates :prefecture_name, presence: true, on: :update, if: :postal_code_changed?
    validates :postalcode_city, presence: true, on: :update, if: :postal_code_changed?
    validates :pando_info, :format => { :with => VALID_URL_REGEX, message: "がフォーマット正しくありません。" }, :allow_blank => true, length: { maximum: 255 }, on: :update, if: :pando_info_changed?
    # validates :current_address, presence: true, if: :current_address_changed?
    # validates :preferred_working_area, presence: true, if: :preferred_working_area_check?
    validates :commitment, length: { maximum: 255}
    validates :qualification_string, length: { maximum: 255}
    attr_accessor :email, :prefecture_name, :region_name, :progress_percent

    accepts_nested_attributes_for :user 
    cattr_accessor :std_commitment_steps do
        %w(step1 step2 step3)
    end
  
    attr_accessor :std_commitment_step, :is_std_commitment_step, :is_kodawari_assessment, :progress_profile, :progress_assessment, :not_step_form

    validates :std_commitment_step, inclusion: { in: self.std_commitment_steps }, if: :std_commitment_step_check?
    
    # step1 validation
    with_options if: lambda { required_for_step?(:step1) } do |step1|
        step1.validates :nick_name, length: { maximum: 200 }, presence: true
    end
    # step2 validation
    with_options if: lambda { required_for_step?(:step2) } do |step2|
        step2.validates :commitment, length: { maximum: 255}
    end  
    
    # def preferred_working_area_check?
    #     # if preferred_working_area.length < 2
    #         errors.add(:preferred_working_area, I18n.t('errors.attributes.desired_location.blank'))
    #     # end
    # end

    def required_for_step?(step)
        return false unless self.std_commitment_steps.include?(std_commitment_step)
        return true if self.std_commitment_steps.index(step.to_s) == self.std_commitment_steps.index(std_commitment_step)
    end

    def std_commitment_step_check?
        is_std_commitment_step == true
    end 

    def kodawari_assessment_check?
        is_kodawari_assessment == true
    end
    
    #Progress
    def progress_calculation
        student_progress(self)
    end
    #Uppercase for last name and first name
    def upcase_fields
        self.last_name.upcase! if self.last_name
        self.first_name.upcase! if self.first_name
        if self.last_name_kana.present?
        self.last_name_kana.upcase!
        end
        if self.first_name_kana.present?
        self.first_name_kana.upcase!
        end
    end

    #company search by student
    def self.company_search_by_association(param)
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        @results = Company::Company.select('companies.*,m_industries.industry_name')
        .joins("INNER JOIN m_regions ON m_regions.id = companies.m_region_id")
        .joins("INNER JOIN m_prefectures ON m_prefectures.id = companies.m_prefecture_id")
        .joins(:m_industries).where("companies.delete_flg = false AND (progress_details -> 3 ->> 'percent')::integer > 0 #{param == "" ? param : 'AND '+ param}").to_a
    end

    #vacancy search by student
    def self.vacancy_search_by_association(param)
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        @results = Company::Vacancy.select('company_vacancies.*,companies.company_name,m_industries.industry_name,m_occupations.occupation_name')
        .joins(:company,:m_industries,:m_occupations)
        .where("CURRENT_DATE BETWEEN company_vacancies.display_from AND company_vacancies.display_to AND company_vacancies.published_flg = true AND company_vacancies.delete_flg = false #{param == "" ? param : 'AND '+ param}").to_a
    end

    #vacancy search by partner
    def self.vacancy_search_by_partner(param,partner_id)
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        @results = Company::Vacancy.select('company_vacancies.*,companies.company_name,m_industries.industry_name,m_occupations.occupation_name')
        .joins(:company,:m_industries,:m_occupations)
        .where("companies.partner_id = #{partner_id} AND CURRENT_DATE BETWEEN company_vacancies.display_from AND company_vacancies.display_to AND company_vacancies.published_flg = true AND company_vacancies.delete_flg = false #{param == "" ? param : 'AND '+ param}").to_a
    end

    #search event by student
    def self.event_search_by_association(partner_id,user_id,param)
        paramVal = if(param.kind_of?(Array))
            param = param.delete_if  {|a| a.empty?}
            param = param.join(" AND ")
            paramVal = param == "" ? param : ' AND '+ param
        else
            paramVal = ' AND events.id =' +param
        end
    
         # 1: 新着、2：募集中、3：満員、4：終了 
            Event.select("events.*,
                CASE WHEN Current_date <= events.application_deadline THEN 
                CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
                ELSE 
                    CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
                    ELSE '2'
                    END	
                END
                ELSE '4' END AS status")
            .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
            .where("events.delete_flg = false #{paramVal} 
            AND events.event_show_option IN(#{Event.event_show_options[:student]},#{Event.event_show_options[:all_user]})
            
            AND ((events.created_by_id = #{partner_id} AND events.event_type = 2)OR
            (events.created_by_id in(select super_partners.id from super_partners 
				inner join partners on partners.super_partner_id = super_partners.id 
				inner join users on users.partner_id = partners.id	where users.id = #{user_id})AND events.event_type = 4 )OR 

            (events.created_by_id in(select companies.id from companies inner join partners on partners.id =  companies.partner_id
                inner join super_partners on super_partners.id = partners.super_partner_id
                where partners.id = #{partner_id}) AND events.event_type = 1 ) OR
            (events.event_type = 3) )

            ")
            .order(status: :ASC,event_start_date: :DESC)
    end

    def self.event_details_by_association(event_id)    
         # 1: 新着、2：募集中、3：満員、4：終了 
            Event.select("events.*,
                CASE WHEN Current_date <= events.application_deadline THEN 
                CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
                ELSE 
                    CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
                    ELSE '2'
                    END	
                END
                ELSE '4' END AS status")
            .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
            .where("events.delete_flg = false AND events.id = #{event_id}")            
    end

    def self.join_event_search_by_association(param)
        paramVal = if(param.kind_of?(Array))
            param = param.delete_if  {|a| a.empty?}
            param = param.join(" AND ")
            paramVal = param == "" ? param : ' AND '+ param
        else
            paramVal = ' AND events.id =' +param
        end
    
         # 1: 新着、2：募集中、3：満員、4：終了 
            Event.select("events.*,
                CASE WHEN Current_date <= events.application_deadline THEN 
                CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
                ELSE 
                    CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
                    ELSE '2'
                    END	
                END
                ELSE '4' END AS status")
            .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
            .where("events.delete_flg = false #{paramVal} AND events.event_show_option IN(#{Event.event_show_options[:student]},#{Event.event_show_options[:all_user]})")
            .order(status: :ASC,event_start_date: :DESC)
    end

    #search past/finish event list
    def self.search_past_event
        Event.where("events.delete_flg = false and CURRENT_DATE > events.application_deadline")
        .order(event_end_date: :DESC).to_a
    end

    #get favourite company list
    def get_favourite_company_list(student_id)
        Company::Company.select("companies.*,apply_favourite_transictions.std_com_favourite,m_industries.industry_name,action_date")
        .joins(:m_industries,:apply_favourite_transictions)
        .where("companies.delete_flg = false and apply_favourite_transictions.std_com_favourite = ? and apply_favourite_transictions.student_id = ?", true, student_id)
        .order("companies.company_name")
    end

    #get favourite vacancy list
    def get_favourite_vacancy_list(student_id)
        Company::Vacancy.select("company_vacancies.*,companies.company_name,m_industries.industry_name,m_occupations.occupation_name,vacancy_apply_favourites.favourite_flg, vacancy_apply_favourites.apply_flg")
        .joins(:company,:m_industries,:m_occupations,:vacancy_apply_favourites)        
        .where("company_vacancies.delete_flg = false and vacancy_apply_favourites.favourite_flg = ? and vacancy_apply_favourites.student_id = ?", true, student_id)
    end

    #get student scouted result list
    def get_student_scouted_result(student_id,parms)
        parms = parms.delete_if { |a| a.empty? }
        param = parms.join(" AND ")
        scouted_result = Company::Company.select("companies.*,communications.id as communication_id,communications.scout_date,communications.scout_status,company_vacancies.vacancy_title")  
                        .joins("INNER JOIN communications ON communications.company_id = companies.id") 
                        .joins(" INNER JOIN company_vacancies ON company_vacancies.id = communications.vacancy_id") 
                        .where("communications.user_id = ? and company_vacancies.delete_flg = ? ",  student_id ,false ) 
                        .order("communications.scout_date DESC")
        unless param.nil?
            scouted_result = scouted_result.where(param)
        end         
    end

    #get favourite event list
    def get_favourite_event_list(student_id)
        Event.select("events.*,apply_favourite_transictions.event_favourite")
        .joins(:apply_favourite_transictions) 
        .where("events.delete_flg = false and apply_favourite_transictions.event_favourite = ? and apply_favourite_transictions.student_id = ?", true, student_id)
        .order("events.event_start_date DESC")
    end

    #get published event list
    def get_join_event_list(student_id)
        Event.select("events.*,apply_favourite_transictions.event_join")
        .joins(:apply_favourite_transictions) 
        .where("events.delete_flg = false and apply_favourite_transictions.event_join = ? and apply_favourite_transictions.student_id = ?", true, student_id)
        .order("events.event_start_date DESC")
    end 
    
    def get_join_company_event_list(student_id)
        Event.select("events.*")
        .joins(:apply_favourite_transictions) 
        .where("events.delete_flg = false and apply_favourite_transictions.event_join = ? and apply_favourite_transictions.student_id = ?", true, student_id)
        .order("events.event_start_date DESC")
    end

    def get_join_admin_event_lists(user_id)
        Event.select("events.*")
        .joins(" LEFT JOIN admin_event_participants ON admin_event_participants.admin_event_id = events.id ")
        .where("events.delete_flg = false and admin_event_participants.user_id = ?", user_id)
        .order("events.event_start_date DESC")
    end  
    
    #get published event list
    def get_join_admin_event_list(user_id)
        Admin::EventParticipant.select("admin_events.*")
        .joins(" LEFT JOIN admin_events ON admin_events.id = admin_event_participants.admin_event_id ")
        .where('admin_event_participants.user_id = ? ',user_id)
        .order("admin_events.event_start_date DESC")
    end   

    # get Top3 Favourite Student
    def show_top_3_fav_student()
        Student::Student.select("count(apply_favourite_transictions.student_id) AS fav_count,CONCAT(last_name, ' ', first_name) AS student_name,apply_favourite_transictions.student_id,students.user_id")
        .joins(:apply_favourite_transictions)
        .where("date(apply_favourite_transictions.created_at) >= '#{Date.today.at_beginning_of_month.strftime('%Y-%m-%d')}' and date(apply_favourite_transictions.created_at) <= '#{Date.today.end_of_month.strftime('%Y-%m-%d')}' and apply_favourite_transictions.com_std_favourite = true and students.delete_flg = 'false'")
        .group("apply_favourite_transictions.student_id,CONCAT(last_name, ' ', first_name),students.last_name,students.user_id")
        .order("count(apply_favourite_transictions.student_id) DESC,students.last_name")
    end

    # get Student Count By Region
    def get_student_count_by_region()
        Student::Student.select("COALESCE( NULLIF(m_regions.region_name,'') ,'未選択') AS region,count(students.user_id)")
        .left_joins(:m_regions)
        .where("date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' and students.delete_flg = 'false'")
        .group('m_regions.id,m_regions.region_name')
        .order('m_regions.id')
    end

    # get Student Count By School Type
    def get_student_count_by_schooltype()
        Student::Student.select("COALESCE( NULLIF(students.school_type,NULL) ,0) AS schooltype,count(students.user_id)")
        .where("date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND students.delete_flg = 'false'")
        .group('school_type')
        .order('school_type')
    end

    # get Student Count By STEAMS sport Info
    def get_student_count_by_steamsinfo()
        Student::Student.select("count(students.id) AS std_count,CASE WHEN is_beelab_activity_participate ISNULL THEN '#{I18n.t('select.not_select')}' 
        WHEN is_beelab_activity_participate = 'true' THEN '#{I18n.t('dashboard.participate')}'
        ELSE '#{I18n.t('dashboard.non_participate')}' END AS isbeelabactivityparticipate")
        .where("date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND students.delete_flg = 'false'")
        .group('isbeelabactivityparticipate')
    end

       # get Student Count By School Type
    def get_student_by_mailtype()
        Student::Student.select("distinct(students.id)")
        .left_joins(:m_regions)
        .where("students.delete_flg = 'false' and communications.mail_type = 2 ")

    end

    #get partner list
    def get_partner_news_list(option_type)
        Kodawarione::News.select("admins.first_name, admins.last_name, news.*")
        .joins("INNER JOIN admins ON admins.id = news.created_user_id ")
            .where("news.delete_flg = 'false' AND news.show_option && ARRAY[?]", option_type)
            .order('created_at DESC')
    end

    def get_partner_news(news_id)
        Kodawarione::News.select("admins.first_name, admins.last_name, news.*")
        .joins("INNER JOIN admins ON admins.id = news.created_user_id ")
        .where("news.id = ? and news.delete_flg = 'false' ", news_id)
        .order('created_at DESC').take
    end

    # Super Partner Dashboard
    def get_student_count_by_region_for_super_partner(super_partner_id)
        Student::Student.select("COALESCE( NULLIF(m_regions.region_name,'') ,'未選択') AS region,count(students.user_id)")
        .left_joins(:m_regions)
        .joins("LEFT JOIN users on users.id = students.user_id")
        .where(       
            "students.user_id in(select users.id from users 
            INNER JOIN partners on users.partner_id = partners.id where users.partner_id in (select id from partners where partners.super_partner_id = '#{super_partner_id}')) 
            AND date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND students.delete_flg = 'false' " 
        )
        .group('m_regions.id,m_regions.region_name')
        .order('m_regions.id')
    end

    def get_student_count_by_schooltype_for_super_partner(super_partner_id)
        Student::Student.select("COALESCE( NULLIF(students.school_type,NULL) ,0) AS schooltype,count(students.user_id)")
        .joins("LEFT JOIN users on users.id = students.user_id")
        .where(       
            "students.user_id in(select users.id from users 
            INNER JOIN partners on users.partner_id = partners.id where users.partner_id in (select id from partners where partners.super_partner_id = '#{super_partner_id}')) 
            AND date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND students.delete_flg = 'false' " 
        )
        .group('school_type')
        .order('school_type')
    end

    def get_student_count_for_partner_details(partner_id)
        Student::Student.find_by_sql(
        ("(SELECT CASE WHEN count(students.id) IS NULL THEN 0 ELSE count(students.id) END, 0 AS gender_name 
        FROM students
        LEFT JOIN users ON users.id = students.user_id
        WHERE date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND students.delete_flg = 'false' AND users.partner_id = '#{partner_id}' AND gender = 0) 
        UNION ALL
        (SELECT CASE WHEN count(students.id) IS NULL THEN 0 ELSE count(students.id) END, 1 AS gender_name 
        FROM students
        LEFT JOIN users ON users.id = students.user_id
        WHERE date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND students.delete_flg = 'false' AND users.partner_id = '#{partner_id}' AND gender = 1)
        UNION ALL
        (SELECT CASE WHEN count(students.id) IS NULL THEN 0 ELSE count(students.id) END, 2 AS gender_name 
        FROM students
        LEFT JOIN users ON users.id = students.user_id
        WHERE date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND students.delete_flg = 'false' AND users.partner_id = '#{partner_id}' AND gender = 2)                                           
        ")
        )
    end

    def get_student_count_for_super_partner_details(superPartnerIdParam)
        Student::Student.find_by_sql("
        (SELECT CASE WHEN count(students.id) IS NULL THEN 0 ELSE count(students.id) END, 0 AS gender_name 
        FROM students
        LEFT JOIN users on users.id = students.user_id
        WHERE students.user_id in(select users.id from users 
        INNER JOIN partners on users.partner_id = partners.id WHERE users.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}')) 
        AND date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND students.delete_flg = 'false' AND gender = 0)
        UNION ALL
        (SELECT CASE WHEN count(students.id) IS NULL THEN 0 ELSE count(students.id) END, 1 AS gender_name 
        FROM students
        LEFT JOIN users on users.id = students.user_id
        WHERE students.user_id in(select users.id from users 
        INNER JOIN partners on users.partner_id = partners.id WHERE users.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}')) 
        AND date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND students.delete_flg = 'false' AND gender = 1)
        UNION ALL
        (SELECT CASE WHEN count(students.id) IS NULL THEN 0 ELSE count(students.id) END, 2 AS gender_name 
        FROM students
        LEFT JOIN users on users.id = students.user_id
        WHERE students.user_id in(select users.id from users 
        INNER JOIN partners on users.partner_id = partners.id WHERE users.partner_id in (select id from partners where partners.super_partner_id = '#{superPartnerIdParam}')) 
        AND date(students.created_at) <= '#{Date.today.strftime('%Y-%m-%d')}' AND students.delete_flg = 'false' AND gender = 2)
        ")
    end

    # private

    def stu_edit_validation
        not_step_form == "true" ? true : false
    end
end