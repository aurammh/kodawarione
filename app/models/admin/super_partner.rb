class Admin::SuperPartner < ApplicationRecord
    belongs_to :m_regions, class_name: "MRegion", foreign_key: "m_region_id",optional: true
    belongs_to :m_prefectures, class_name: "MPrefecture", foreign_key: "m_prefecture_id",optional: true
    self.table_name = "super_partners"
    attr_accessor :prefecture_name,:region_name

    validates :name, length: { maximum: 255 }, presence: true
    validates :website_url, presence: true, :format => { :with => VALID_URL_REGEX, message: "がフォーマット正しくありません。" }, length: { maximum: 255 },  if: :website_url_changed?
    validates :address, length: { maximum: 255 }, presence: true,if: :address_changed?
    validates :display_address, presence: true
    validates :postal_code, presence: true, if: :postal_code_changed?
    validates :phone_no, presence: true, length: { within: 6..20 }
    validates :postalcode_city, presence: true
    validates :m_prefecture_id, presence: true
    validates :m_region_id , presence: true

    #========================================================================================
    #               Search for admin's super partner setting
    #========================================================================================
    scope :admin_setting_super_partner_all_init_list, ->(code, keyword){
        columnNames = columnNames = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnNames.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        code_search = code.nil? ? '' : " AND lower(super_partners.super_partner_code) LIKE lower('%#{code}%')"
        select('super_partners.*')
        .where(       
            " super_partners.delete_flg = 'false'" +keyword_search + code_search)
        .order("super_partners.created_at DESC")
    }
    
    #search with keyword
    scope :admin_su_partners_all_list, ->(keyword){
        columnName = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('super_partners.*')
        .where("super_partners.delete_flg = 'false'" + keyword_search)
        .order('super_partners.created_at desc')
    }

    #search with start date and keyword
    scope :admin_su_partners_search_by_date_from, ->(startDate, keyword){
        columnName = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select("super_partners.*")
        .where("date(super_partners.created_at) >= '#{startDate}' AND super_partners.delete_flg  = 'false'" + keyword_search)
        .order("super_partners.created_at DESC")
    }

    #search with end date and keyword
    scope :admin_su_partners_search_by_date_to, ->(endDate, keyword){
        columnName = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select("super_partners.*")
        .where("date(super_partners.created_at) <= '#{endDate}' AND super_partners.delete_flg  = 'false'" + keyword_search)
        .order("super_partners.created_at DESC")
    }

    #search with all fields
    scope :admin_su_partners_search_by_date_between, ->(startDate,endDate, keyword){
        columnName = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select("super_partners.*")
        .where("date(super_partners.created_at) >= '#{startDate}' AND date(super_partners.created_at) <= '#{endDate}' AND super_partners.delete_flg  = 'false'" + keyword_search)
        .order("super_partners.created_at DESC")
    }
end
