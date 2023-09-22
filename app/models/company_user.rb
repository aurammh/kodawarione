class CompanyUser < ApplicationRecord
  has_one :company_member, class_name: "Company::CompanyMember", foreign_key: "user_id", dependent: :destroy
  has_one_attached :image
  self.table_name = "company_users"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :timeoutable, :lockable, :trackable

      scope :partner_company_user_lists_by_company_id, ->(company_id){
        select('company_users.*, company_members.company_id')
        .where(       
            "company_users.delete_flg = 'false' AND company_members.company_id = #{company_id}")
        .joins("LEFT JOIN company_members on company_members.user_id = company_users.id")
        .order("company_users.created_at DESC")
        }

      scope :partner_company_user_lists_by_admin_company_id, ->(admin_company_id, keyword, name){
        columnNames = ["email"]
        keyword_search = keyword.nil? ? '' : " AND (#{columnNames.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
        name_search = name.nil? ? '' : " AND (lower(company_users.first_name) || '' || lower(company_users.last_name)) LIKE lower('%#{name}%')"
          select('company_users.*, company_members.company_id')
          .where(       
              "company_users.delete_flg = 'false' AND company_members.company_id = #{admin_company_id}"+ keyword_search + name_search)
          .joins("LEFT JOIN company_members on company_members.user_id = company_users.id")
          .order("company_users.created_at DESC")
          }


      scope :admin_company_user_lists_by_company_id, ->(company_id){
          select('company_users.*, company_members.company_id')
          .where(       
              "company_users.delete_flg = 'false' AND company_members.company_id = #{company_id}")
          .joins("LEFT JOIN company_members on company_members.user_id = company_users.id")
          .order("company_users.created_at DESC")
          }
      
      scope :admin_company_user_lists_by_admin_company_id, ->(admin_company_id, keyword, name){
            columnNames = ["email"]
            keyword_search = keyword.nil? ? '' : " AND (#{columnNames.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
            name_search = name.nil? ? '' : " AND (lower(company_users.first_name) || '' || lower(company_users.last_name)) LIKE lower('%#{name}%')"
            select('company_users.*, company_members.company_id')
            .where(       
                "company_users.delete_flg = 'false' AND company_members.company_id = #{admin_company_id}"+ keyword_search + name_search)
            .joins("LEFT JOIN company_members on company_members.user_id = company_users.id")
            .order("company_users.created_at DESC")
            }
         
  attr_accessor :company_name, :check_password, :terms_and_conditions,:privacy_policy,:confirm_member_token, :contact_person_last_name, :contact_person_first_name

  validates :email,:format => { :with => VALID_EMAIL_REGEX, message: "がフォーマット正しくありません。" }, presence: true,on: :create

   

  validates :company_name,  length: { maximum: 255 }, presence: true,on: :create, if: -> { last_name.blank? && first_name.blank?}
  
  # after_create :skip_confirmation!
  # for user setting
  attr_accessor :check_password, :current_password, :check_current_password, :check_update, :chk_pass_edit,:chk_edit_email,:check_email
  validates :email, uniqueness: true, length: { maximum: 255 }, presence: true,on: :update, if: :check_email
  # password validation
  validates :current_password, presence: true, if: :check_current_password
  validates :password, presence: true, if: :check_password
  validates_confirmation_of :password, if: :check_password
  validates :first_name, length: { maximum: 255 }, presence: true ,on: :update  , allow_blank: false, if: :first_name_changed
  validates :last_name, length: { maximum: 255 }, presence: true ,on: :update  , allow_blank: false , if: :last_name_changed

  def chief_administrator?
    self.company_member.company_roles_id == 1 ? true : false
  end

  def admin?
    self.company_member.company_roles_id == 2 ? true : false
  end

  def member?
    self.company_member.company_roles_id == 3 ? true : false
  end

  private

  def devise_mailer
    User::UserMailer
  end
  
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

  def first_name_changed
    if first_name.blank?
      errors.add(:first_name) 
    end 
  end

  def last_name_changed
    if last_name.blank?
      errors.add(:last_name) 
    end
  end
  
end
