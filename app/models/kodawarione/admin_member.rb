class Kodawarione::AdminMember < ApplicationRecord
    belongs_to :admins, class_name: "Admin"
    belongs_to :kodawarione_admin_roles, class_name: "Kodawarione::AdminRole", foreign_key: "admin_roles_id", optional: true
    belongs_to :super_partners, class_name: "Admin::SuperPartner ", foreign_key: "super_partners_id", optional: true
    belongs_to :partners, class_name: "Partner::Partner", foreign_key: "partners_id", optional: true
  
    self.table_name = "admin_members"
end
