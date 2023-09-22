class Kodawarione::RolePermission < ApplicationRecord
    has_many :role_permission, class_name: "Kodawarione::RolePermission", foreign_key: "permission_id"
    self.table_name = "role_permissions"

    scope :permissions, -> (){joins("LEFT JOIN permissions on permissions.id = role_permissions.permission_id")}
end
