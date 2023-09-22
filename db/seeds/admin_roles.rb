Kodawarione::AdminRole.new(role_type: "chief_administrator").save(validate: false)
Kodawarione::AdminRole.new(role_type: "super_partner").save(validate: false)
Kodawarione::AdminRole.new(role_type: "partner").save(validate: false)

Kodawarione::AdminMember.create!(admins_id: 1, admin_roles_id: 1)
