Admin.create!(email: "admin-kodawarione@kodawarione.com",password: "admin123",admin_code: "BL000001",last_name: "Beelab",first_name: "Admin",user_type: 0)
Admin.create!(email: "admin-istd@istd.co.jp",password: "admin123",admin_code: "BL000002",last_name: "Istd",first_name: "Admin",user_type: 0)
Admin::MPermissionType.create!(id: 1 ,permission_type: "login_enable",use_student: true)
Admin::MPermissionType.create!(id: 2 ,permission_type: "vacancy_create",use_student: false)
Admin::MPermissionType.create!(id: 3 ,permission_type: "event_create",use_student: false)
Admin::MPermissionType.create!(id: 4 ,permission_type: "communication_enable",use_student: true ,use_company: true ,)