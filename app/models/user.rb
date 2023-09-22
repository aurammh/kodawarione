require 'securerandom'
require "open-uri"
class User < ApplicationRecord
  has_one :company, class_name: "Company::Company", :inverse_of => :user, foreign_key: "user_id", dependent: :destroy
  has_one :student, class_name: "Student::Student", foreign_key: "user_id", dependent: :destroy
  has_one :permission, class_name: "Admin::Permission", foreign_key: "user_id", dependent: :destroy
  has_many :admin_event_participants, class_name: "Admin::EventParticipant", foreign_key: "user_id"
  # accepts_nested_attributes_for :company, reject_if: :all_blank
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,:recoverable, :rememberable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2, :line]

   #search update active flag from admin
   scope :admin_student_setting_all, -> { select("users.*,students.id as std_id,students.birthday,students.last_name || ' ' ||students.first_name as name").joins(:student).where("students.delete_flg='false'").order('first_name')}
   student_columnName = ["email","(CASE WHEN birthday IS NULL THEN '本登録未完了' ELSE '本登録完了' END)"]
   scope :admin_student_search_setting, ->(name, keyword) { 
    keyword_search = keyword.nil? ? '' : " AND (#{student_columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    name_search = name.nil? ? '' : " AND (lower(students.last_name) || ' ' || lower(students.first_name)) LIKE lower('%#{name}%')"
    select("users.*,students.id as std_id, students.birthday,students.last_name || ' ' ||students.first_name as name")
    .joins(:student)
    .where("students.delete_flg='false'" + name_search + keyword_search)
    .order('first_name') } 
   
   scope :admin_company_setting_all, -> { select('users.*,companies.id as com_id ,companies.company_name_kana , companies.company_name as cp_name').joins(:company).where("companies.delete_flg='false'").order('company_name')}
   columnName = ["user_name","email","(CASE WHEN company_name_kana IS NULL THEN '本登録未完了' ELSE '本登録完了' END)"]
   scope :admin_company_search_setting, ->(name, keyword) {
    keyword_search = keyword.nil? ? '' : " AND (#{columnName.map {|field| "lower(#{field}) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    name_search = name.nil? ? '' : " AND lower(companies.company_name) LIKE lower('%#{name}%')"
    select('users.*,companies.id as com_id ,companies.company_name_kana , companies.company_name as cp_name')
    .joins(:company)
    .where("companies.delete_flg='false'" + name_search + keyword_search)
    .order('company_name') }      

  validates :email,:format => { :with => VALID_EMAIL_REGEX, message: "がフォーマット正しくありません。" }, presence: true,on: :create

  attr_accessor :login, :last_name, :first_name,:company_name,:company_email,:tnc_and_policy,:confirm_member_token
  validates :tnc_and_policy, acceptance: true

  # after_create :skip_confirmation!
  # for user setting
  attr_accessor :check_password, :current_password, :chk_edit_username, :check_username, :check_current_password, :check_update, :chk_pass_edit,:chk_edit_email,:check_email
  validates :email, uniqueness: true, length: { maximum: 255 }, presence: true,on: :update, if: :check_email
  # password validation
  validates :current_password, presence: true, if: :check_current_password
  validates :password, presence: true, if: :check_password
  validates_confirmation_of :password, if: :check_password

  def self.from_omniauth(auth, check_param)
    name_split = auth.info.name.split(" ")
    if auth.provider == "line"
      user = User.where(uid: auth.uid).first
    else
      user = User.where(email: auth.info.email).first
    end
    if user.nil?
      user = User.new
      user.provider = auth.provider
      user.email = auth.info.email ? auth.info.email : "#{auth.uid}-#{auth.provider}@kodawari.com"
      user.password = Devise.friendly_token[0, 20]
      user.uid = auth.uid
      user.skip_confirmation!

      # Partner Code Check
      all_partner = Partner::Partner.select(:partner_code, :id, :name)
      shared_partner = if check_param.present? && BCrypt::Password.valid_hash?(check_param)
                          all_partner.find { |val| BCrypt::Password.new(check_param) == val.partner_code }
                        else
                          all_partner.first
                        end
      user.partner_id = shared_partner.id
      user.save(validate: false)

      student = Student::Student.new
      student.nick_name = auth.info.name
      student.user_id = user.id
      student.first_name = auth.info.name.split.first
      if  auth.info.name.split.count > 1
        student.last_name = auth.info.name.split[(auth.info.name.split.count-1)..-1].join(' ')
      end
      begin
        url = URI.parse(auth.info.image)
        file = URI.open(url)
        filename = "kodawari_one_" + SecureRandom.hex(10)
        student.image.attach(io: file, filename: filename,content_type: "image/jpeg",)
      rescue => exception
        
      end
      student.save(validate: false)
    end
    return user
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
end