class Partner::Partner < ApplicationRecord
    belongs_to :m_regions, class_name: "MRegion", foreign_key: "m_region_id",optional: true
    belongs_to :m_prefectures, class_name: "MPrefecture", foreign_key: "m_prefecture_id",optional: true
    self.table_name = "partners"
    attr_accessor :prefecture_name,:region_name

    #search with keyword
    scope :admin_partners_all_list, ->(keyword){
        columnName = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('partners.*')
        .where("partners.delete_flg = 'false'" + keyword_search)
        .order('partners.created_at desc')
    }

    #search with start date and keyword
    scope :admin_partners_search_by_date_from, ->(startDate, keyword){
        columnName = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select("partners.*")
        .where("date(partners.created_at) >= '#{startDate}' AND partners.delete_flg  = 'false'" + keyword_search)
        .order("created_at DESC")
    }

    #search with end date and keyword
    scope :admin_partners_search_by_date_to, ->(endDate, keyword){
        columnName = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select("partners.*")
        .where("date(partners.created_at) <= '#{endDate}' AND partners.delete_flg  = 'false'" + keyword_search)
        .order("created_at DESC")
    }

    #search with all fields
    scope :admin_partners_search_by_date_between, ->(startDate,endDate, keyword){
        columnName = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select("partners.*")
        .where("date(partners.created_at) >= '#{startDate}' AND date(partners.created_at) <= '#{endDate}' AND partners.delete_flg  = 'false'" + keyword_search)
        .order("created_at DESC")
    }

     #========================================================================================
    #               Search for spu's partner
    #========================================================================================

    #search with keyword
    scope :spu_partners_all_list, ->(keyword, superPartnerIdParam){
        columnName = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('partners.*')
        .where("partners.delete_flg = 'false' AND partners.super_partner_id = '#{superPartnerIdParam}'" + keyword_search)
        .order('partners.created_at desc')
    }

    #search with start date and keyword
    scope :spu_partners_search_by_date_from, ->(startDate, keyword, superPartnerIdParam){
        columnName = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select("partners.*")
        .where("date(partners.created_at) >= '#{startDate}' AND partners.delete_flg  = 'false' AND partners.super_partner_id = '#{superPartnerIdParam}'" + keyword_search)
        .order("created_at DESC")
    }

    #search with end date and keyword
    scope :spu_partners_search_by_date_to, ->(endDate, keyword, superPartnerIdParam){
        columnName = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select("partners.*")
        .where("date(partners.created_at) <= '#{endDate}' AND partners.delete_flg  = 'false' AND partners.super_partner_id = '#{superPartnerIdParam}'" + keyword_search)
        .order("created_at DESC")
    }

    #search with all fields
    scope :spu_partners_search_by_date_between, ->(startDate,endDate, keyword, superPartnerIdParam){
        columnName = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select("partners.*")
        .where("date(partners.created_at) >= '#{startDate}' AND date(partners.created_at) <= '#{endDate}' AND partners.delete_flg  = 'false' AND partners.super_partner_id = '#{superPartnerIdParam}'" + keyword_search)
        .order("created_at DESC")
    }

    #========================================================================================
    #               Search for admin's partner setting
    #========================================================================================
    scope :admin_setting_partner_all_init_list, ->(code, keyword){
        columnNames = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnNames.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        code_search = code.nil? ? '' : " AND lower(partners.partner_code) LIKE lower('%#{code}%')"
        select('partners.*')
        .where(       
            " partners.delete_flg = 'false'" +keyword_search + code_search)
        .order("partners.created_at DESC")
        }

    # get partners from super partner
    scope :super_partner_setting_partner_all_init_list, ->(super_partner_id, code, keyword){
        columnNames = ["name","display_address","website_url"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnNames.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        code_search = code.nil? ? '' : " AND lower(partners.partner_code) LIKE lower('%#{code}%')"
        select('partners.*')
        .where(       
            " partners.delete_flg = 'false' and partners.super_partner_id = #{super_partner_id}" +keyword_search + code_search)
        .order("partners.created_at DESC")
        }

    validates :name, length: { maximum: 255 }, presence: true
    validates :website_url, presence: true, :format => { :with => VALID_URL_REGEX, message: "がフォーマット正しくありません。" }, length: { maximum: 255 },  if: :website_url_changed?
    validates :address, length: { maximum: 255 }, presence: true,if: :address_changed?
    validates :display_address, presence: true
    validates :postal_code, presence: true, if: :postal_code_changed?
    validates :phone_no, presence: true, length: { within: 6..20 }
    validates :postalcode_city, presence: true
    validates :m_prefecture_id, presence: true
    validates :m_region_id , presence: true

    #get partner count by postalcode_city
    def get_partner_count_by_postalcode_city()
        Partner::Partner.select("COALESCE( NULLIF(partners.postalcode_city,'') ,'未選択') AS city, count(partners.id)")
        .where("partners.delete_flg = 'false'")
        .group('partners.postalcode_city')
    end

    # get Partner Count By Region
    def get_partner_count_by_region()
        Partner::Partner.select("COALESCE( NULLIF(m_regions.region_name,'') ,'未選択') AS region,count(partners.id)")
        .joins(" LEFT JOIN m_regions ON m_regions.id = partners.m_region_id")
        .where("partners.delete_flg = 'false'")
        .group('m_regions.id,m_regions.region_name')
        .order('m_regions.id')
    end
    
end
