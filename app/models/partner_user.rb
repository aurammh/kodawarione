class PartnerUser < ApplicationRecord
  belongs_to :partners, class_name: "Partner::Partner", foreign_key: "partner_id",optional: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one_attached :avatar
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  attr_accessor :check_password, :current_password, :check_current_password, :check_update, :chk_pass_edit,:chk_edit_email,:check_email

  columnName = ["first_name","last_name","email"]
  #search with keyword
  scope :admin_partners_users_all_list, ->(keyword,partner_id){
        keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        select('partner_users.*')
        .where("partner_users.delete_flg = 'false' AND partner_users.partner_id = #{partner_id} " + keyword_search)
        .order('partner_users.created_at desc')
  }
  #search with start date and keyword
  scope :admin_partners_user_search_by_date_from, ->(startDate, keyword,partner_id){
    keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    select("partner_users.*")
    .where("date(partner_users.created_at) >= '#{startDate}' AND partner_users.partner_id = #{partner_id} AND  partner_users.delete_flg  = 'false'" + keyword_search)
    .order("created_at DESC")
  }

  #search with end date and keyword
  scope :admin_partners_user_search_by_date_to, ->(endDate, keyword,partner_id){
      keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
      select("partner_users.*")
      .where("date(partner_users.created_at) <= '#{endDate}' AND partner_users.partner_id = #{partner_id} AND partner_users.delete_flg  = 'false'" + keyword_search)
      .order("created_at DESC")
  }

  #search with all fields
  scope :admin_partners_user_search_by_date_between, ->(startDate,endDate, keyword,partner_id){
      keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}::text) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
      select("partner_users.*")
      .where("date(partner_users.created_at) >= '#{startDate}' AND date(partner_users.created_at) <= '#{endDate}' AND partner_users.partner_id = #{partner_id} AND partner_users.delete_flg  = 'false'" + keyword_search)
      .order("created_at DESC")
  }

  #========================================================================================
  #               Search for admin's super partner details setting 
  #========================================================================================
  scope :admin_partner_user_lists_by_id, ->(partner_id,name,keyword){
    columnNames = ["email"]
    keyword_search = keyword.nil? ? '' : " AND (#{columnNames.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    name_search = name.nil? ? '' : " AND (lower(partner_users.first_name) || '' || lower(partner_users.last_name)) LIKE lower('%#{name}%')"
    select('partner_users.*')
    .where(       
        " partner_users.delete_flg = 'false' AND partner_users.partner_id = #{partner_id}" +keyword_search + name_search)
    .order("partner_users.created_at DESC")
  }
    
  scope :super_partner_partner_user_lists_by_id, ->(partner_id,name,keyword){
    columnNames = ["email"]
    keyword_search = keyword.nil? ? '' : " AND (#{columnNames.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    name_search = name.nil? ? '' : " AND (lower(partner_users.first_name) || '' || lower(partner_users.last_name)) LIKE lower('%#{name}%')"
    select('partner_users.*')
    .where(       
        " partner_users.delete_flg = 'false' AND partner_users.partner_id = #{partner_id}" +keyword_search + name_search)
    .order("partner_users.created_at DESC")
  }

  validates :email, uniqueness: true, length: { maximum: 255 }, presence: true,on: :update, if: :check_email
  validates :password_confirmation, presence: true,on: :create
  # password validation
  validates :current_password, presence: true, if: :check_current_password
  validates :password, presence: true, if: :check_password
  validates_confirmation_of :password, if: :check_password

  validates :first_name, length: { maximum: 255 }, presence: true
  validates :last_name, length: { maximum: 255 }, presence: true

  def password_required?
    if self.check_update
      if self.check_password
        return true
        super
      else
        return false
      end
    else
      new_record? ? false : super
    end
  end
end
