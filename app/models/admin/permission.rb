class Admin::Permission < ApplicationRecord
    belongs_to :user, class_name: "User", optional: true
    belongs_to :admin_permission_type ,class_name: "Admin::MPermissionType"
end
