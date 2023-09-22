class Event < ApplicationRecord
    self.table_name = "events"
    belongs_to :company, -> { where "event_type = 1" }, class_name: "Company::Company", foreign_key: "created_by_id", optional: true
    has_many :apply_favourite_transictions, class_name: "ApplyFavouriteTransiction", foreign_key: "event_id"
    has_many :admin_event_participants, class_name: "Admin::EventParticipant", foreign_key: "admin_event_id"
    has_one_attached :event_image
    has_rich_text :event_content
    has_one :action_text_rich_text,class_name: 'ActionText::RichText',as: :record
    
    #enum for event_show_option options
    enum event_show_option: { super_partner:5 ,partner:4, company: 1, student: 2, all_user: 3}

    enum event_organizers: { admin_event: 1, super_partner_event: 2, partner_event: 3,  company_event: 4 }

    #enum for event_category options
    enum event_category: { com_info_explancation: 1, related_com_explanation: 2, internship: 3, part_time_job_recruit: 4, seminar_recruit:5, sponsored_recruit: 6, marketing: 7, other_session: 8 }

    validates :event_name, length: { maximum: 255 }, presence: true
    validates :venue_types, presence: true
    validates :venue, length: { maximum: 255 }, presence: true
    validates :category,presence: true
    validates :event_content, presence: true
    validates :event_start_date, presence: true, on: [:create, :update]
    validates :event_end_date, presence: true, on: [:create, :update]
    validates :post_start_date, presence: true, on: [:create, :update]
    validates :post_end_date, presence: true, on: [:create, :update]
    validates :application_start_date, presence: true, on: [:create, :update]
    validates :application_deadline, presence: true, on: [:create, :update]
    validate :must_have_one_category
    validates :event_show_option, presence: true
    validates :apply_event_limit, presence: true, numericality: { only_integer: true }
    
    
    def must_have_one_category
        errors.add(:category, 'を選択してください。') if self.category.length == 1 &&  self.category[0] == nil
    end

    #search past/finish event list
    def self.search_past_event(id)
        Event.where("events.created_by_id = #{id} AND events.event_type = 1 AND events.delete_flg = false and CURRENT_DATE > events.application_deadline")
        .order(event_end_date: :DESC).to_a
    end
    # =======================================================
    #         Event Search by COMPANY
    # =======================================================
    #search event by company
    def self.company_event_search_by_association(param)
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
        .joins(" INNER JOIN companies ON companies.id = events.created_user_id ")
        .where("events.delete_flg = false #{paramVal} AND event_type != 1 AND event_show_option IN (#{Event.event_show_options[:company]},#{Event.event_show_options[:all_user]})")
        .order(status: :ASC,event_start_date: :DESC)
    end


    # =======================================================
    #         Company Event Search by Admin
    # =======================================================
    admin_company_event_columnName = ["company_name","event_name","venue"]
    scope :admin_company_event_search_init_list, ->(keyword, param){
        keyword_search = keyword.nil? ? '' : " AND (#{admin_company_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        select("events.*, companies.company_name")
        .joins(:company)
        .where(
        "events.delete_flg = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
        )
        .order("event_start_date DESC")
    }
    scope :admin_company_event_search_by_only_start_date, ->(date_type, startDate, keyword, param){
        keyword_search = keyword.nil? ? '' : " AND (#{admin_company_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        select("events.*, companies.company_name")
        .joins(:company)
        .where(       
            "date(events.#{date_type}) >= '#{startDate}' AND events.delete_flg  = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
        )
        .order("event_start_date DESC")
    }
    scope :admin_company_event_search_by_only_end_date, ->(date_type, endDate, keyword, param){
        keyword_search = keyword.nil? ? '' : " AND (#{admin_company_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        select("events.*, companies.company_name")
        .joins(:company)
        .where(       
            "date(events.#{date_type}) <= '#{endDate}' AND events.delete_flg  =  'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
        )
        .order("event_start_date DESC")
    }
    scope :admin_company_event_search_by_between_two_date, ->(date_type, startDate, endDate, keyword, param){
        keyword_search = keyword.nil? ? '' : " AND (#{admin_company_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        select("events.*, companies.company_name")
        .joins(:company)
            .where(       
            "date(events.#{date_type}) >= '#{startDate}' AND date(events.#{date_type}) <= '#{endDate}' AND events.delete_flg  = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
            )
        .order("event_start_date DESC")
    }

    # =======================================================
    #         Company Event Search by Partner
    # =======================================================
    partner_company_event_columnName = ["company_name","event_name","venue"]
    scope :partner_company_event_search_init_list, ->(keyword, partner_id, param){
    keyword_search = keyword.nil? ? '' : " AND (#{partner_company_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, companies.company_name")
    .joins(:company)
    .where(
      "events.delete_flg = 'false' and companies.partner_id = '#{partner_id}' AND CURRENT_DATE BETWEEN events.post_start_date AND events.post_end_date" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :partner_company_event_search_by_only_start_date, ->(date_type, startDate, keyword, partner_id, param){
    keyword_search = keyword.nil? ? '' : " AND (#{partner_company_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, companies.company_name")
    .joins(:company)
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND events.delete_flg = 'false' and companies.partner_id = '#{partner_id}' AND CURRENT_DATE BETWEEN events.post_start_date AND events.post_end_date" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :partner_company_event_search_by_only_end_date, ->(date_type, endDate, keyword, partner_id, param){
    keyword_search = keyword.nil? ? '' : " AND (#{partner_company_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, companies.company_name")
    .joins(:company)
    .where(       
        "date(events.#{date_type}) <= '#{endDate}' AND events.delete_flg  = 'false' and companies.partner_id = '#{partner_id}' AND CURRENT_DATE BETWEEN events.post_start_date AND events.post_end_date" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :partner_company_event_search_by_between_two_date, ->(date_type, startDate, endDate, keyword, partner_id, param){
    keyword_search = keyword.nil? ? '' : " AND (#{partner_company_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, companies.company_name")
   .joins(:company)
    .where(       
       "date(events.#{date_type}) >= '#{startDate}' AND date(events.#{date_type}) <= '#{endDate}' AND events.delete_flg  = 'false' and companies.partner_id = '#{partner_id}' AND CURRENT_DATE BETWEEN events.post_start_date AND events.post_end_date" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
   .order("event_start_date DESC")
    }

    # =======================================================
    #         Company Event Search by Super Partner
    # =======================================================

    super_partner_company_event_columnName = ["company_name","event_name","venue"]
    scope :super_partner_company_event_search_list, ->(super_partner_id, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_company_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, companies.company_name")
    .joins(:company)
    .where(
      "events.created_by_id in(select companies.id from companies
      inner join partners on partners.id = companies.partner_id
      inner join super_partner_users on super_partner_users.id = partners.super_partner_id
      where super_partner_users.super_partner_id = #{super_partner_id}) AND events.delete_flg = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :super_partner_company_event_search_by_only_end_date, ->(super_partner_id, date_type, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_company_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, companies.company_name")
    .joins(:company)
    .where(       
        "date(events.#{date_type}) <= '#{endDate}' AND events.created_by_id in(select companies.id from companies
        inner join partners on partners.id = companies.partner_id
        inner join super_partner_users on super_partner_users.id = partners.super_partner_id
        where super_partner_users.super_partner_id = #{super_partner_id}) AND events.delete_flg  =  'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :super_partner_company_event_search_by_only_start_date, ->(super_partner_id, date_type, startDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_company_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, companies.company_name")
    .joins(:company)
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND events.created_by_id in(select companies.id from companies
        inner join partners on partners.id = companies.partner_id
        inner join super_partner_users on super_partner_users.id = partners.super_partner_id
        where super_partner_users.super_partner_id = #{super_partner_id}) AND events.delete_flg  = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :super_partner_company_event_search_by_between_two_date, ->(super_partner_id, date_type, startDate, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_company_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, companies.company_name")
   .joins(:company)
    .where(       
       "date(events.#{date_type}) >= '#{startDate}' AND date(events.#{date_type}) <= '#{endDate}' AND events.created_by_id in(select companies.id from companies
       inner join partners on partners.id = companies.partner_id
       inner join super_partner_users on super_partner_users.id = partners.super_partner_id
       where super_partner_users.super_partner_id = #{super_partner_id}) AND events.delete_flg  = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    } 

    # =======================================================
    #               Admin Event Search by self
    # =======================================================
    admin_admin_event_columnName = ["event_name","venue"]
    scope :admin_admin_event_search_init_list, ->(keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*")
    .where(
      "events.delete_flg = 'false' AND events.event_type = 3" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :admin_admin_event_search_by_only_end_date, ->(date_type, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*")
    .where(       
        "date(events.#{date_type}) <= '#{endDate}' AND events.event_type = 3 AND events.delete_flg  =  'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :admin_admin_event_search_by_only_start_date, ->(date_type, startDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND events.event_type = 3 AND events.delete_flg  = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :admin_admin_event_search_by_between_two_date, ->(date_type, startDate, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND date(events.#{date_type}) <= '#{endDate}' AND events.event_type = 3 AND events.delete_flg  = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }
    
    # ==========================================================
    #               Admin Event Search by Super Partner
    # ==========================================================

    admin_admin_event_columnName = ["event_name","venue"]
    scope :super_partner_admin_event_search_init_list, ->(keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,
    CASE WHEN Current_date <= events.application_deadline THEN 
        CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
        ELSE 
            CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
            ELSE '2'
            END	
        END
    ELSE '4' END AS status")
    .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
    .where(
      "events.delete_flg = 'false' AND events.event_type = 3 AND event_show_option IN (#{Event.event_show_options[:super_partner]},#{Event.event_show_options[:all_user]})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :super_partner_admin_event_search_by_only_end_date, ->(date_type, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,
    CASE WHEN Current_date <= events.application_deadline THEN 
        CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
        ELSE 
            CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
            ELSE '2'
            END	
        END
    ELSE '4' END AS status")
    .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
    .where(       
        "date(events.#{date_type}) <= '#{endDate}' AND events.event_type = 3 AND events.delete_flg  =  'false' AND event_show_option IN (#{Event.event_show_options[:super_partner]},#{Event.event_show_options[:all_user]})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :super_partner_admin_event_search_by_only_start_date, ->(date_type, startDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,
    CASE WHEN Current_date <= events.application_deadline THEN 
        CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
        ELSE 
            CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
            ELSE '2'
            END	
        END
    ELSE '4' END AS status")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND events.event_type = 3 AND events.delete_flg  = 'false' AND event_show_option IN (#{Event.event_show_options[:super_partner]},#{Event.event_show_options[:all_user]})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
    .order("event_start_date DESC")
    }
    scope :super_partner_admin_event_search_by_between_two_date, ->(date_type, startDate, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,
    CASE WHEN Current_date <= events.application_deadline THEN 
        CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
        ELSE 
            CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
            ELSE '2'
            END	
        END
    ELSE '4' END AS status")
    .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND date(events.#{date_type}) <= '#{endDate}' AND events.event_type = 3 AND events.delete_flg  = 'false' AND event_show_option IN (#{Event.event_show_options[:super_partner]},#{Event.event_show_options[:all_user]})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    # =======================================================
    #               Admin Event Search by Partner
    # =======================================================
    admin_admin_event_columnName = ["event_name","venue"]
    scope :partner_admin_event_search_init_list, ->(keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,
    CASE WHEN Current_date <= events.application_deadline THEN 
    CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
    ELSE 
        CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
            ELSE '2'
        END	
    END
    ELSE '4' END AS status")
    .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
    .where(
      "events.delete_flg = 'false' AND events.event_type = 3 AND event_show_option IN (#{Event.event_show_options[:partner]},#{Event.event_show_options[:all_user]})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :partner_admin_event_search_by_only_end_date, ->(date_type, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,
    CASE WHEN Current_date <= events.application_deadline THEN 
    CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
    ELSE 
        CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
            ELSE '2'
        END	
    END
    ELSE '4' END AS status")
    .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
    .where(       
        "date(events.#{date_type}) <= '#{endDate}' AND events.event_type = 3 AND events.delete_flg  =  'false' AND event_show_option IN (#{Event.event_show_options[:partner]},#{Event.event_show_options[:all_user]})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :partner_admin_event_search_by_only_start_date, ->(date_type, startDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,
    CASE WHEN Current_date <= events.application_deadline THEN 
    CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
    ELSE 
        CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
            ELSE '2'
        END	
    END
    ELSE '4' END AS status")
    .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND events.event_type = 3 AND events.delete_flg  = 'false' AND event_show_option IN (#{Event.event_show_options[:partner]},#{Event.event_show_options[:all_user]})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :partner_admin_event_search_by_between_two_date, ->(date_type, startDate, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,
    CASE WHEN Current_date <= events.application_deadline THEN 
    CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
    ELSE 
        CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
            ELSE '2'
        END	
    END
    ELSE '4' END AS status")
    .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND date(events.#{date_type}) <= '#{endDate}' AND events.event_type = 3 AND events.delete_flg  = 'false' AND event_show_option IN (#{Event.event_show_options[:partner]},#{Event.event_show_options[:all_user]})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    
    # =======================================================
    #               Partner Event Search
    # =======================================================
    partner_partner_event_columnName = ["event_name","venue"]
    scope :partner_partner_event_search_init_list, ->(keyword, param, partner_id){
    keyword_search = keyword.nil? ? '' : " AND (#{partner_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*")
    .joins("LEFT JOIN partners on partners.id = events.created_by_id")
    .where(
        "events.delete_flg = 'false' AND partners.id = '#{partner_id}' AND events.event_type = 2" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :partner_partner_event_search_by_only_end_date, ->(date_type, endDate, keyword, param, partner_id){
    keyword_search = keyword.nil? ? '' : " AND (#{partner_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*")
    .joins("LEFT JOIN partners on partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) <= '#{endDate}' AND events.delete_flg = 'false' AND partners.id = '#{partner_id}' AND events.event_type = 2" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :partner_partner_event_search_by_only_start_date, ->(date_type, startDate, keyword, param, partner_id){
    keyword_search = keyword.nil? ? '' : " AND (#{partner_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*")
    .joins("LEFT JOIN partners on partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND events.delete_flg = 'false' AND partners.id = '#{partner_id}' AND events.event_type = 2" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :partner_partner_event_search_by_between_two_date, ->(date_type, startDate, endDate, keyword, param, partner_id){
    keyword_search = keyword.nil? ? '' : " AND (#{partner_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*")
    .joins("LEFT JOIN partners on partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND date(events.#{date_type}) <= '#{endDate}' AND events.delete_flg = 'false' AND partners.id = '#{partner_id}' AND events.event_type = 2" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    # =======================================================
    #         Partner Event Search by Admin
    # =======================================================
    admin_partner_event_columnName = ["partner_code", "event_name", "venue"]
    scope :admin_partner_event_search_init_list, ->(keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, partners.partner_code")
    .joins("LEFT JOIN partners on partners.id = events.created_by_id")
    .where(
        "events.delete_flg = 'false' AND events.event_type = 2" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :admin_partner_event_search_by_only_end_date, ->(date_type, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, partners.partner_code")
    .joins("LEFT JOIN partners on partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) <= '#{endDate}' AND events.delete_flg = 'false' AND events.event_type = 2" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :admin_partner_event_search_by_only_start_date, ->(date_type, startDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, partners.partner_code")
    .joins("LEFT JOIN partners on partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND events.delete_flg = 'false' AND events.event_type = 2" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :admin_partner_event_search_by_between_two_date, ->(date_type, startDate, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, partners.partner_code")
    .joins("LEFT JOIN partners on partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND date(events.#{date_type}) <= '#{endDate}' AND events.delete_flg = 'false' AND events.event_type = 2" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    # =======================================================
    #         Partner Event Search by Super Partner
    # =======================================================
    super_partner_partner_event_columnName = ["partner_code", "event_name", "venue"]
    scope :super_partner_partner_event_search_list, ->(super_partner_id, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, partners.partner_code")
    .joins("LEFT JOIN partners on partners.id = events.created_by_id")
    .where(
        "events.delete_flg = 'false' AND events.event_type = 2 AND events.created_by_id in (select partners.id from partners
        inner join super_partner_users on super_partner_users.id = partners.super_partner_id
        where super_partner_users.super_partner_id = #{super_partner_id})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :super_partner_partner_event_search_by_only_end_date, ->(super_partner_id, date_type, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, partners.partner_code")
    .joins("LEFT JOIN partners on partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) <= '#{endDate}' AND events.delete_flg = 'false' AND events.event_type = 2 AND events.created_by_id in (select partners.id from partners
        inner join super_partner_users on super_partner_users.id = partners.super_partner_id
        where super_partner_users.super_partner_id = #{super_partner_id})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :super_partner_partner_event_search_by_only_start_date, ->(super_partner_id, date_type, startDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, partners.partner_code")
    .joins("LEFT JOIN partners on partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND events.delete_flg = 'false' AND events.event_type = 2 AND events.created_by_id in (select partners.id from partners
        inner join super_partner_users on super_partner_users.id = partners.super_partner_id
        where super_partner_users.super_partner_id = #{super_partner_id})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :super_partner_partner_event_search_by_between_two_date, ->(super_partner_id, date_type, startDate, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*, partners.partner_code")
    .joins("LEFT JOIN partners on partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND date(events.#{date_type}) <= '#{endDate}' AND events.delete_flg = 'false' AND events.event_type = 2 AND events.created_by_id in (select partners.id from partners
        inner join super_partner_users on super_partner_users.id = partners.super_partner_id
        where super_partner_users.super_partner_id = #{super_partner_id})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    # ===================================================================
    #             Super Partner Event Search by self 
    # ===================================================================
    admin_admin_event_columnName = ["event_name","venue"]
    scope :super_partner_event_search_all_list, ->(keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,super_partners.super_partner_code")
    .joins("LEFT JOIN super_partners on super_partners.id = events.created_by_id")
    .where(
      "events.delete_flg = 'false' AND events.event_type = 4 " + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :super_partner_event_search_by_only_end_date, ->(date_type, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,super_partners.super_partner_code")
    .joins("LEFT JOIN super_partners on super_partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) <= '#{endDate}' AND events.event_type = 4 AND events.delete_flg  =  'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :super_partner_event_search_by_only_start_date, ->(date_type, startDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,super_partners.super_partner_code")
    .joins("LEFT JOIN super_partners on super_partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND events.event_type = 4 AND events.delete_flg  = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :super_partner_event_search_by_between_two_date, ->(date_type, startDate, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{admin_admin_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,super_partners.super_partner_code")
    .joins("LEFT JOIN super_partners on super_partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND date(events.#{date_type}) <= '#{endDate}' AND events.event_type = 4 AND events.delete_flg  = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    # ===================================================================
    #             Super Partner Event Search by Partner 
    # ===================================================================    
    super_partner_event_columnName = ["event_name","venue"]
    scope :partner_super_partner_event_search_all_list, ->(super_partner_id, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,super_partners.super_partner_code,
    CASE WHEN Current_date <= events.application_deadline THEN 
        CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
        ELSE 
            CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
                ELSE '2'
            END	
        END
    ELSE '4' END AS status")
    .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
    .joins("LEFT JOIN super_partners on super_partners.id = events.created_by_id")
    .where(
      "events.delete_flg = 'false' AND events.event_type = 4 and events.created_by_id = #{super_partner_id} AND event_show_option IN (#{Event.event_show_options[:partner]},#{Event.event_show_options[:all_user]})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :partner_super_partner_event_search_by_only_end_date, ->(super_partner_id, date_type, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,super_partners.super_partner_code,
    CASE WHEN Current_date <= events.application_deadline THEN 
        CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
        ELSE 
            CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
                ELSE '2'
            END	
        END
    ELSE '4' END AS status")
    .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
    .joins("LEFT JOIN super_partners on super_partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) <= '#{endDate}' AND events.event_type = 4 AND events.delete_flg  =  'false' and events.created_by_id = #{super_partner_id} AND event_show_option IN (#{Event.event_show_options[:partner]},#{Event.event_show_options[:all_user]})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :partner_super_partner_event_search_by_only_start_date, ->(super_partner_id, date_type, startDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,super_partners.super_partner_code,
    CASE WHEN Current_date <= events.application_deadline THEN 
        CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
        ELSE 
            CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
                ELSE '2'
            END	
        END
    ELSE '4' END AS status")
    .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
    .joins("LEFT JOIN super_partners on super_partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND events.event_type = 4 AND events.delete_flg  = 'false' and events.created_by_id = #{super_partner_id} AND event_show_option IN (#{Event.event_show_options[:partner]},#{Event.event_show_options[:all_user]})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    scope :partner_super_partner_event_search_by_between_two_date, ->(super_partner_id, date_type, startDate, endDate, keyword, param){
    keyword_search = keyword.nil? ? '' : " AND (#{super_partner_event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword}%')"}.join(' or ')})"
    param = param.delete_if  {|a| a.empty?}
    param = param.join(" AND ")
    select("events.*,super_partners.super_partner_code,
    CASE WHEN Current_date <= events.application_deadline THEN 
        CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
        ELSE 
            CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
                ELSE '2'
            END	
        END
    ELSE '4' END AS status")
    .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
    .joins("LEFT JOIN super_partners on super_partners.id = events.created_by_id")
    .where(       
        "date(events.#{date_type}) >= '#{startDate}' AND date(events.#{date_type}) <= '#{endDate}' AND events.event_type = 4 AND events.delete_flg  = 'false' and events.created_by_id = #{super_partner_id} AND event_show_option IN (#{Event.event_show_options[:partner]},#{Event.event_show_options[:all_user]})" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
    )
    .order("event_start_date DESC")
    }

    # ===================================================================
    #  Admin Search all events
    # ===================================================================   

    event_columnName = ["event_name","venue"]
    scope :event_search_init_list, ->(keyword, param){
        keyword_search = keyword.nil? ? '' : " AND (#{event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        select("events.*") 
        .where(
        "events.delete_flg = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
        )
        .order("event_start_date DESC")
    } 
    scope :event_search_by_only_start_date, ->(date_type, startDate, keyword, param){
        keyword_search = keyword.nil? ? '' : " AND (#{event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        select("events.*") 
        .where(       
            "date(events.#{date_type}) >= '#{startDate}' AND events.delete_flg  = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
        )
        .order("event_start_date DESC")
    }  
    scope :event_search_by_only_end_date, ->(date_type, endDate, keyword, param){
        keyword_search = keyword.nil? ? '' : " AND (#{event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        select("events.*") 
        .where(       
            "date(events.#{date_type}) <= '#{endDate}' AND events.delete_flg  =  'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
        )
        .order("event_start_date DESC")
    } 
    scope :event_search_by_between_two_date, ->(date_type, startDate, endDate, keyword, param){
        keyword_search = keyword.nil? ? '' : " AND (#{event_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        param = param.delete_if  {|a| a.empty?}
        param = param.join(" AND ")
        select("events.*") 
        .where(       
           "date(events.#{date_type}) >= '#{startDate}' AND date(events.#{date_type}) <= '#{endDate}' AND events.delete_flg  = 'false'" + keyword_search + "#{param == "" ? param : 'AND '+ param}"
        )
       .order("event_start_date DESC")
    }

    # ===================================================================
    #  Admin Search all events apply method
    # ===================================================================  
    def apply_event_student_list(event_id)
        join_event_list = Student::Student.select('students.*,student_commitment_abilities.status ')
        .joins(:apply_favourite_transictions)
        .joins("FULL OUTER JOIN student_commitment_abilities ON student_commitment_abilities.student_id = students.id AND student_commitment_abilities.status = 'active'")
        .where("apply_favourite_transictions.event_join= ? and apply_favourite_transictions.event_id= ?",true, event_id)
        return join_event_list
    end

    private
    def event_venue_type_validation
        venue_types === "1" ? true : false
    end
end