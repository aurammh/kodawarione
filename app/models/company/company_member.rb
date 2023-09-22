class Company::CompanyMember < ApplicationRecord
    belongs_to :company_roles, class_name: "Company::Role", foreign_key: "company_roles_id",optional: true
    belongs_to :company_users, class_name: "CompanyUser", foreign_key: "user_id",optional: true
    has_one_attached :image
    has_secure_token :confirmation_token, length: 60
    self.table_name = "company_members"
    
    validates :user_email, uniqueness: true, :format => { :with => VALID_EMAIL_REGEX, message: "がフォーマット正しくありません。" }, presence: true, on: [:create, :update]
    validates :company_roles_id, length: { maximum: 8 }, presence: true, on: [:create, :update] 
    validates :department, presence: true, on: [:create, :update]
    validates :position, presence: true, on: [:create, :update]
end
