class Admin::EventParticipant < ApplicationRecord
    belongs_to :event, class_name: "Event", foreign_key: "admin_event_id"
    has_one_attached :image
    self.table_name  = "admin_event_participants"

    # ========================================================================
    #       Super Partner Participant Search and Details
    # ========================================================================
    partner_column_name = ["name"]
    scope :super_partner_participants_for_admin_events_all_lists, ->(event_id, super_partner_name_keyword){
        partner_name_search = partner_column_name.nil? ? '' : " AND (#{partner_column_name.map {|field| "lower(#{field}) like lower('%#{super_partner_name_keyword}%')"}.join(' or ')})"
        select('super_partners.name, events.event_name, count(super_partner_id) as participants_count, admin_event_participants.super_partner_id, admin_event_participants.admin_event_id')
        .where("admin_event_participants.delete_flg = 'false'and admin_event_participants.admin_event_id = #{event_id} and admin_event_participants.super_partner_id IS NOT NULL" + partner_name_search) 
        .joins("LEFT JOIN super_partners on super_partners.id = admin_event_participants.super_partner_id")
        .joins("LEFT JOIN events on admin_event_participants.admin_event_id = events.id ") 
        .group("super_partners.name, events.event_name, admin_event_participants.admin_event_id, admin_event_participants.super_partner_id")
    }

    scope :super_partner_participants_for_admin_events_detail_list, ->(super_partner_id, event_id){
        select('admin_event_participants.*, super_partner_users.first_name, super_partner_users.last_name, super_partner_users.email')
        .where("admin_event_participants.super_partner_id = #{super_partner_id} AND admin_event_id = #{event_id} AND admin_event_participants.delete_flg  = 'false'")
        .joins("LEFT JOIN super_partners on admin_event_participants.super_partner_id = super_partners.id") 
        .joins("LEFT JOIN super_partner_users on super_partner_users.id = admin_event_participants.super_partner_user_id") 
    }

    # ========================================================================
    #       Partner Participant Search and Details
    # ========================================================================
    partner_column_name = ["name"]
    scope :partner_participants_for_admin_events_all_lists, ->(event_id, partner_name){
        partner_name_search = partner_column_name.nil? ? '' : " AND (#{partner_column_name.map {|field| "lower(#{field}) like lower('%#{partner_name}%')"}.join(' or ')})"
        select('partners.name, events.event_name, count(partner_id) as participants_count, admin_event_participants.partner_id, admin_event_participants.admin_event_id')
        .where("admin_event_participants.delete_flg = 'false'and admin_event_participants.admin_event_id = #{event_id} and admin_event_participants.partner_id IS NOT NULL" + partner_name_search) 
        .joins("LEFT JOIN partners on partners.id = admin_event_participants.partner_id")
        .joins("LEFT JOIN events on admin_event_participants.admin_event_id = events.id ") 
        .group("partners.name, events.event_name, admin_event_participants.admin_event_id, admin_event_participants.partner_id")
    }

    scope :partner_participants_for_admin_events_detail_list, ->(partner_id, event_id){
        select('admin_event_participants.*, partner_users.first_name, partner_users.last_name, partner_users.email')
        .where("admin_event_participants.partner_id = #{partner_id} AND admin_event_id = #{event_id} AND admin_event_participants.delete_flg  = 'false'")
        .joins("LEFT JOIN partners on admin_event_participants.partner_id = partners.id") 
        .joins("LEFT JOIN partner_users on partner_users.id = admin_event_participants.partner_user_id") 
    }

    scope :partner_participants_for_super_partner_events_all_lists, ->(event_id, partner_name){
        partner_name_search = partner_column_name.nil? ? '' : " AND (#{partner_column_name.map {|field| "lower(#{field}) like lower('%#{partner_name}%')"}.join(' or ')})"
        select('partners.name, events.event_name, count(partner_id) as participants_count, admin_event_participants.partner_id, admin_event_participants.admin_event_id')
        .where("admin_event_participants.delete_flg = 'false'and admin_event_participants.admin_event_id = #{event_id} and admin_event_participants.partner_id IS NOT NULL" + partner_name_search) 
        .joins("LEFT JOIN partners on partners.id = admin_event_participants.partner_id")
        .joins("LEFT JOIN events on admin_event_participants.admin_event_id = events.id ") 
        .group("partners.name, events.event_name, admin_event_participants.admin_event_id, admin_event_participants.partner_id")
    }

    scope :partner_participants_for_super_events_details_list, ->(participant_partner_id, participant_event_id){
        select('admin_event_participants.*, partner_users.first_name, partner_users.last_name, partner_users.email')
        .where("admin_event_participants.partner_id = #{participant_partner_id} AND admin_event_id = #{participant_event_id} AND admin_event_participants.delete_flg  = 'false'")
        .joins("LEFT JOIN partners on admin_event_participants.partner_id = partners.id") 
        .joins("LEFT JOIN partner_users on partner_users.id = admin_event_participants.partner_user_id") 
    }

    # ========================================================================
    #       Company Participant Search and Details
    # ========================================================================
    company_column_name = ["company_name"]
    event_column_name = ["event_name"]
    scope :company_participants_for_admin_events_all_lists, ->(event_id, company_name_keyword, event_name_keyword){
        company_keyword_search = company_column_name.nil? ? '' : " AND (#{company_column_name.map {|field| "lower(#{field}) like lower('%#{company_name_keyword}%')"}.join(' or ')})"
        event_keyword_search = event_column_name.nil? ? '' : " AND (#{event_column_name.map {|field| "lower(#{field}) like lower('%#{event_name_keyword}%')"}.join(' or ')})"
        select('companies.company_name, events.event_name, count(company_id) as participants_count, admin_event_participants.company_id, admin_event_participants.admin_event_id')
        .where("admin_event_participants.delete_flg = 'false'and admin_event_participants.admin_event_id = #{event_id} and admin_event_participants.company_id IS NOT NULL" + company_keyword_search + event_keyword_search)
        .joins("LEFT JOIN companies on admin_event_participants.company_id = companies.id")
        .joins("LEFT JOIN events on admin_event_participants.admin_event_id = events.id ") 
        .group("companies.company_name, events.event_name, admin_event_participants.admin_event_id, admin_event_participants.company_id")
    }
    
    scope :company_participants_for_admin_events_details_list, ->(participants_company_id, participants_event_id){
        select('admin_event_participants.updated_at, company_users.first_name, company_users.last_name, company_members.department, company_members.position, company_users.email')
        .where("admin_event_participants.company_id = #{participants_company_id} AND admin_event_id = #{participants_event_id} AND admin_event_participants.delete_flg  = 'false'")
        .joins("LEFT JOIN company_members on admin_event_participants.company_user_id = company_members.user_id")
        .joins("LEFT JOIN companies on admin_event_participants.company_id = companies.id")  
        .joins("LEFT JOIN events on admin_event_participants.admin_event_id = events.id")
        .joins("LEFT JOIN company_users on admin_event_participants.company_user_id = company_users.id")
    }

    scope :company_participants_for_super_partner_events_all_lists, ->(event_id, company_name_keyword, event_name_keyword){
        company_keyword_search = company_column_name.nil? ? '' : " AND (#{company_column_name.map {|field| "lower(#{field}) like lower('%#{company_name_keyword}%')"}.join(' or ')})"
        event_keyword_search = event_column_name.nil? ? '' : " AND (#{event_column_name.map {|field| "lower(#{field}) like lower('%#{event_name_keyword}%')"}.join(' or ')})"
        select('companies.company_name, events.event_name, count(company_id) as participants_count, admin_event_participants.company_id, admin_event_participants.admin_event_id')
        .where("admin_event_participants.delete_flg = 'false'and admin_event_participants.admin_event_id = #{event_id} and admin_event_participants.company_id IS NOT NULL" + company_keyword_search + event_keyword_search)
        .joins("LEFT JOIN companies on admin_event_participants.company_id = companies.id")
        .joins("LEFT JOIN events on admin_event_participants.admin_event_id = events.id ") 
        .group("companies.company_name, events.event_name, admin_event_participants.admin_event_id, admin_event_participants.company_id")
    }

    scope :company_participants_for_super_partner_events_details_list, ->(participants_company_id, participants_event_id){
        select('admin_event_participants.updated_at, company_users.first_name, company_users.last_name, company_members.department, company_members.position, company_users.email')
        .where("admin_event_participants.company_id = #{participants_company_id} AND admin_event_id = #{participants_event_id} AND admin_event_participants.delete_flg  = 'false'")
        .joins("LEFT JOIN company_members on admin_event_participants.company_user_id = company_members.user_id")
        .joins("LEFT JOIN companies on admin_event_participants.company_id = companies.id")  
        .joins("LEFT JOIN events on admin_event_participants.admin_event_id = events.id")
        .joins("LEFT JOIN company_users on admin_event_participants.company_user_id = company_users.id")
    }

    scope :company_participants_for_partner_events_all_list, ->(event_id, company_name_keyword, event_name_keyword){
        company_keyword_search = company_column_name.nil? ? '' : " AND (#{company_column_name.map {|field| "lower(#{field}) like lower('%#{company_name_keyword}%')"}.join(' or ')})"
        event_keyword_search = event_column_name.nil? ? '' : " AND (#{event_column_name.map {|field| "lower(#{field}) like lower('%#{event_name_keyword}%')"}.join(' or ')})"
        select('companies.company_name, events.event_name, count(company_id) as participants_count, admin_event_participants.company_id, admin_event_participants.admin_event_id')
        .where("admin_event_participants.delete_flg = 'false'and admin_event_participants.admin_event_id = #{event_id} and admin_event_participants.company_id IS NOT NULL" + company_keyword_search + event_keyword_search)
        .joins("LEFT JOIN companies on admin_event_participants.company_id = companies.id")
        .joins("LEFT JOIN events on admin_event_participants.admin_event_id = events.id ") 
        .group("companies.company_name, events.event_name, admin_event_participants.admin_event_id, admin_event_participants.company_id")
    }

    scope :company_participants_for_super_events_details_list, ->(participants_company_id, participants_event_id){
        select('admin_event_participants.updated_at, company_users.first_name, company_users.last_name, company_members.department, company_members.position, company_users.email')
        .where("admin_event_participants.company_id = #{participants_company_id} AND admin_event_id = #{participants_event_id} AND admin_event_participants.delete_flg  = 'false'")
        .joins("LEFT JOIN company_members on admin_event_participants.company_user_id = company_members.user_id")
        .joins("LEFT JOIN companies on admin_event_participants.company_id = companies.id")  
        .joins("LEFT JOIN events on admin_event_participants.admin_event_id = events.id")
        .joins("LEFT JOIN company_users on admin_event_participants.company_user_id = company_users.id")
    }

    # ========================================================================
    #       Student Participant Search and Details
    # ========================================================================
    user_column_name = ["first_name","last_name"]
    user_event_column_name = ["event_name"]
    scope :user_participants_for_admin_events_all_lists, ->(event_id, user_name_keyword){
        name_search = user_name_keyword.nil? ? '' : " and ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{user_name_keyword.gsub(/'/, "''") }%'))"
        # user_keyword_search = user_column_name.nil? ? '' : " AND (#{user_column_name.map {|field| "lower(#{field}) like lower('%#{user_name_keyword}%')"}.join(' or ')})"
        # user_event_keyword_search = user_event_column_name.nil? ? '' : " AND (#{user_event_column_name.map {|field| "lower(#{field}) like lower('%#{user_event_name_keyword}%')"}.join(' or ')})"
        select('admin_event_participants.updated_at,students.nick_name, students.last_name, students.first_name, users.email, events.event_name, admin_event_participants.company_id, admin_event_participants.admin_event_id')
        .where("admin_event_participants.delete_flg = 'false' and admin_event_participants.admin_event_id = #{event_id} and admin_event_participants.user_id IS NOT NULL" + name_search )
        .joins("LEFT JOIN students on admin_event_participants.user_id = students.user_id")
        .joins("LEFT JOIN events on admin_event_participants.admin_event_id = events.id")
        .joins("LEFT JOIN users on admin_event_participants.user_id = users.id")
    }

    user_column_name = ["first_name","last_name"]
    user_event_column_name = ["event_name"]
    scope :user_participants_for_super_partner_events_all_lists, ->(event_id, user_name_keyword){
        name_search = user_name_keyword.nil? ? '' : " and ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{user_name_keyword.gsub(/'/, "''") }%'))"
        # user_keyword_search = user_column_name.nil? ? '' : " AND (#{user_column_name.map {|field| "lower(#{field}) like lower('%#{user_name_keyword}%')"}.join(' or ')})"
        # user_event_keyword_search = user_event_column_name.nil? ? '' : " AND (#{user_event_column_name.map {|field| "lower(#{field}) like lower('%#{user_event_name_keyword}%')"}.join(' or ')})"
        select('admin_event_participants.updated_at, students.last_name, students.first_name, users.email, events.event_name, admin_event_participants.company_id, admin_event_participants.admin_event_id')
        .where("admin_event_participants.delete_flg = 'false' and admin_event_participants.admin_event_id = #{event_id} and admin_event_participants.user_id IS NOT NULL" + name_search )
        .joins("LEFT JOIN students on admin_event_participants.user_id = students.user_id")
        .joins("LEFT JOIN events on admin_event_participants.admin_event_id = events.id")
        .joins("LEFT JOIN users on admin_event_participants.user_id = users.id")
    }

    scope :user_participants_for_partner_events_all_list, ->(event_id, user_name_keyword){
        name_search = user_name_keyword.nil? ? '' : " and ((lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{user_name_keyword.gsub(/'/, "''") }%'))"
        # user_keyword_search = user_column_name.nil? ? '' : " AND (#{user_column_name.map {|field| "lower(#{field}) like lower('%#{user_name_keyword}%')"}.join(' or ')})"
        # user_event_keyword_search = user_event_column_name.nil? ? '' : " AND (#{user_event_column_name.map {|field| "lower(#{field}) like lower('%#{user_event_name_keyword}%')"}.join(' or ')})"
        select('admin_event_participants.updated_at, students.last_name, students.first_name, users.email, events.event_name, admin_event_participants.company_id, admin_event_participants.admin_event_id')
        .where("admin_event_participants.delete_flg = 'false' and admin_event_participants.admin_event_id = #{event_id} and admin_event_participants.user_id IS NOT NULL" + name_search )
        .joins("LEFT JOIN students on admin_event_participants.user_id = students.user_id")
        .joins("LEFT JOIN events on admin_event_participants.admin_event_id = events.id")
        .joins("LEFT JOIN users on admin_event_participants.user_id = users.id")
    }
    
end