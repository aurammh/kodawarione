class Kodawarione::CompanyRole < ApplicationRecord
    has_many :role_permission, class_name: "Company::RolePermission", foreign_key: "role_id"
    before_validation :downcase_fields
    self.table_name = "company_roles"
    validates :role_type,  presence: true, uniqueness: {scope: :company_id}, exclusion: { in: %w(admin member),
        message: "%{value} is reserved." }
    def downcase_fields
        self.role_type.downcase! if self.role_type
    end
end
