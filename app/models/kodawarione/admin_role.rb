class Kodawarione::AdminRole < ApplicationRecord
    self.table_name = "admin_roles"
    has_many :admin_members, class_name: "Kodawarione::AdminMember", foreign_key: "admin_roles_id"
end
