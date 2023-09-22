# Activity
Kodawarione::Permission.new(permission_name: "company_activity_index" , action_name: "read" , permission_model_name: "Company::Activity", permission_for: 4, permission_default_can: false, permission_group: "company_activity", remark: "/company/activities/[index,show]").save
# Kodawarione::Permission.new(permission_name: "company_activity_show" , action_name: "show" , permission_model_name: "Company::Activity", permission_for: 4, permission_default_can: false, permission_group: "company_activity", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_activity_new" , action_name: "create" , permission_model_name: "Company::Activity", permission_for: 4, permission_default_can: false, permission_group: "company_activity", remark: "/company/activities/[new,create]").save
# Kodawarione::Permission.new(permission_name: "company_activity_create" , action_name: "create" , permission_model_name: "Company::Activity", permission_for: 4, permission_default_can: false, permission_group: "company_activity", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_activity_edit" , action_name: "update" , permission_model_name: "Company::Activity", permission_for: 4, permission_default_can: false, permission_group: "company_activity", remark: "/company/activities/:id/[edit,update]").save
# Kodawarione::Permission.new(permission_name: "company_activity_update" , action_name: "update" , permission_model_name: "Company::Activity", permission_for: 4, permission_default_can: false, permission_group: "company_activity", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_activity_destroy" , action_name: "destroy" , permission_model_name: "Company::Activity", permission_for: 4, permission_default_can: false, permission_group: "company_activity", remark: "/company/activities/:id").save

# Event
Kodawarione::Permission.new(permission_name: "event_index", action_name: "read" , permission_model_name: "Event", permission_for: 4, permission_default_can: false, permission_group: "company_event", remark: "/company/events/[index,show]").save
# Kodawarione::Permission.new(permission_name: "event_show", action_name: "show" , permission_model_name: "Event", permission_for: 4, permission_default_can: false, permission_group: "company_event", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "event_new", action_name: "create" , permission_model_name: "Event", permission_for: 4, permission_default_can: false, permission_group: "company_event", remark: "/company/events/[new,create]").save
# Kodawarione::Permission.new(permission_name: "event_create", action_name: "create" , permission_model_name: "Event", permission_for: 4, permission_default_can: false, permission_group: "company_event", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "event_edit", action_name: "update" , permission_model_name: "Event", permission_for: 4, permission_default_can: false, permission_group: "company_event", remark: "/company/events/:id/[edit,update]").save
# Kodawarione::Permission.new(permission_name: "event_update", action_name: "update" , permission_model_name: "Event", permission_for: 4, permission_default_can: false, permission_group: "company_event", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "event_destroy", action_name: "destroy" , permission_model_name: "Event", permission_for: 4, permission_default_can: false, permission_group: "company_event", remark: "/company/events/:id").save
#Kodawarione::Permission.new(permission_name: "event_save_img", action_name: "save_img" , permission_model_name: "Event", permission_for: 4, permission_default_can: false, permission_group: "company_event", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "event_event_apply_list", action_name: "event_apply_list" , permission_model_name: "Event", permission_for: 4, permission_default_can: false, permission_group: "company_event", remark: "/company/event_apply_list/:id").save
Kodawarione::Permission.new(permission_name: "event_select_past_events", action_name: "select_past_events" , permission_model_name: "Event", permission_for: 4, permission_default_can: false, permission_group: "company_event", remark: "/company/select_past_events").save
Kodawarione::Permission.new(permission_name: "company_company_join_event_student_list" , action_name: "join_event_student_list" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_event", remark: "/company/join_event_student_list/:id").save

# Interview Story
Kodawarione::Permission.new(permission_name: "company_interview_story_index", action_name: "read" , permission_model_name: "Company::InterviewStory", permission_for: 4, permission_default_can: false, permission_group: "company_interview_story", remark: "/company/interview_stories/[index,show]").save
# Kodawarione::Permission.new(permission_name: "company_interview_story_show", action_name: "show" , permission_model_name: "Company::InterviewStory", permission_for: 4, permission_default_can: false, permission_group: "company_interview_story", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_interview_story_new", action_name: "create" , permission_model_name: "Company::InterviewStory", permission_for: 4, permission_default_can: false, permission_group: "company_interview_story", remark: "/company/interview_stories/[new,create]").save
# Kodawarione::Permission.new(permission_name: "company_interview_story_create", action_name: "create" , permission_model_name: "Company::InterviewStory", permission_for: 4, permission_default_can: false, permission_group: "company_interview_story", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_interview_story_edit", action_name: "update" , permission_model_name: "Company::InterviewStory", permission_for: 4, permission_default_can: false, permission_group: "company_interview_story", remark: "/company/interview_stories/:id/[edit,update]").save
# Kodawarione::Permission.new(permission_name: "company_interview_story_update", action_name: "update" , permission_model_name: "Company::InterviewStory", permission_for: 4, permission_default_can: false, permission_group: "company_interview_story", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_interview_story_destroy", action_name: "destroy" , permission_model_name: "Company::InterviewStory", permission_for: 4, permission_default_can: false, permission_group: "company_interview_story", remark: "/company/interview_stories/:id").save
#Kodawarione::Permission.new(permission_name: "company_interview_story_save_created_user_img", action_name: "save_created_user_img" , permission_model_name: "Company::InterviewStory", permission_for: 4, permission_default_can: false, permission_group: "company_interview_story", remark: "company permission url").save

# Permission
Kodawarione::Permission.new(permission_name: "company_permission_index", action_name: "read", permission_model_name: "Kodawarione::Permission", permission_for: 4, permission_default_can: false, permission_group: "company_permission", remark: "/company/permissions/[index,show]").save
# Kodawarione::Permission.new(permission_name: "company_permission_show", action_name: "show", permission_model_name: "Kodawarione::Permission", permission_for: 4, permission_default_can: false, permission_group: "company_permission", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_permission_new", action_name: "create", permission_model_name: "Kodawarione::Permission", permission_for: 4, permission_default_can: false, permission_group: "company_permission", remark: "/company/permissions/[new,create]").save
# Kodawarione::Permission.new(permission_name: "company_permission_create", action_name: "create", permission_model_name: "Kodawarione::Permission", permission_for: 4, permission_default_can: false, permission_group: "company_permission", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_permission_edit", action_name: "update", permission_model_name: "Kodawarione::Permission", permission_for: 4, permission_default_can: false, permission_group: "company_permission", remark: "/company/permissions/:id/[edit,update]").save
# Kodawarione::Permission.new(permission_name: "company_permission_update", action_name: "update", permission_model_name: "Kodawarione::Permission", permission_for: 4, permission_default_can: false, permission_group: "company_permission", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_permission_destroy", action_name: "destroy", permission_model_name: "Kodawarione::Permission", permission_for: 4, permission_default_can: false, permission_group: "company_permission", remark: "/company/permissions/:id").save

# Company Members
Kodawarione::Permission.new(permission_name: "company_company_member_index" , action_name: "read" , permission_model_name: "Company::CompanyMember", permission_for: 4, permission_default_can: false, permission_group: "company_member", remark: "/company/company_members/[index,show]").save
# Kodawarione::Permission.new(permission_name: "company_company_member_show" , action_name: "show" , permission_model_name: "Company::CompanyMember", permission_for: 4, permission_default_can: false, permission_group: "company_member", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_company_member_new" , action_name: "create" , permission_model_name: "Company::CompanyMember", permission_for: 4, permission_default_can: false, permission_group: "company_member", remark: "/company/company_members/[new,create]").save
# Kodawarione::Permission.new(permission_name: "company_company_member_create" , action_name: "create" , permission_model_name: "Company::CompanyMember", permission_for: 4, permission_default_can: false, permission_group: "company_member", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_company_member_edit" , action_name: "update" , permission_model_name: "Company::CompanyMember", permission_for: 4, permission_default_can: false, permission_group: "company_member", remark: "/company/company_members/:id/[edit,update]").save
# Kodawarione::Permission.new(permission_name: "company_company_member_update" , action_name: "update" , permission_model_name: "Company::CompanyMember", permission_for: 4, permission_default_can: false, permission_group: "company_member", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_company_member_destroy" , action_name: "destroy" , permission_model_name: "Company::CompanyMember", permission_for: 4, permission_default_can: false, permission_group: "company_member", remark: "/company/company_members/:id").save
##Kodawarione::Permission.new(permission_name: "company_company_member_get_company_name" , action_name: "get_company_name" , permission_model_name: "Company::CompanyMember", permission_for: 4, permission_default_can: false, permission_group: "company_member", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_company_member_company_member_confirmation" , action_name: "company_member_confirmation" , permission_model_name: "Company::CompanyMember", permission_for: 4, permission_default_can: false, permission_group: "company_member", remark: "/company/company_member_confirmation").save
Kodawarione::Permission.new(permission_name: "company_company_member_company_member_accept" , action_name: "company_member_accept" , permission_model_name: "Company::CompanyMember", permission_for: 4, permission_default_can: false, permission_group: "company_member", remark: "/company/company_member_accept").save
Kodawarione::Permission.new(permission_name: "company_company_member_company_member_reject" , action_name: "company_member_reject" , permission_model_name: "Company::CompanyMember", permission_for: 4, permission_default_can: false, permission_group: "company_member", remark: "/company/company_member_reject").save
##Kodawarione::Permission.new(permission_name: "company_company_member_save_img" , action_name: "save_img" , permission_model_name: "Company::CompanyMember", permission_for: 4, permission_default_can: false, permission_group: "company_member", remark: "company permission url").save

# Company Vacancy
Kodawarione::Permission.new(permission_name: "company_vacancy_index", action_name: "read", permission_model_name: "Company::Vacancy", permission_for: 4, permission_default_can: false, permission_group: "company_vacancy", remark: "/company/vacancies/[index,show]").save
# Kodawarione::Permission.new(permission_name: "company_vacancy_show", action_name: "show", permission_model_name: "Company::Vacancy", permission_for: 4, permission_default_can: false, permission_group: "company_vacancy", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_vacancy_new", action_name: "create", permission_model_name: "Company::Vacancy", permission_for: 4, permission_default_can: false, permission_group: "company_vacancy", remark: "/company/vacancies/[[new,create]").save
# Kodawarione::Permission.new(permission_name: "company_vacancy_create", action_name: "create", permission_model_name: "Company::Vacancy", permission_for: 4, permission_default_can: false, permission_group: "company_vacancy", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_vacancy_edit", action_name: "update", permission_model_name: "Company::Vacancy", permission_for: 4, permission_default_can: false, permission_group: "company_vacancy", remark: "/company/vacancies/:id/[edit,update]").save
# Kodawarione::Permission.new(permission_name: "company_vacancy_update", action_name: "update", permission_model_name: "Company::Vacancy", permission_for: 4, permission_default_can: false, permission_group: "company_vacancy", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_vacancy_destroy", action_name: "destroy", permission_model_name: "Company::Vacancy", permission_for: 4, permission_default_can: false, permission_group: "company_vacancy", remark: "/company/vacancies/:id").save
Kodawarione::Permission.new(permission_name: "company_vacancy_apply_accept", action_name: "apply_accept", permission_model_name: "Company::Vacancy", permission_for: 4, permission_default_can: false, permission_group: "company_vacancy", remark: "/company/apply_accept/:id").save
Kodawarione::Permission.new(permission_name: "company_vacancy_apply_reject", action_name: "apply_reject", permission_model_name: "Company::Vacancy", permission_for: 4, permission_default_can: false, permission_group: "company_vacancy", remark: "/company/apply_reject/:id").save
Kodawarione::Permission.new(permission_name: "company_vacancy_vacancy_applied_student_list", action_name: "vacancy_applied_student_list"    , permission_model_name: "Company::Vacancy", permission_for: 4, permission_default_can: false, permission_group: "company_vacancy", remark: "/company/vacancy_applied_student_list/:id").save
Kodawarione::Permission.new(permission_name: "company_vacancy_vacancy_applied_student_detail", action_name: "vacancy_applied_student_detail", permission_model_name: "Company::Vacancy", permission_for: 4, permission_default_can: false, permission_group: "company_vacancy", remark: "/company/vacancy_applied_student_list/:vacancy_id/student_details/:student_id").save
Kodawarione::Permission.new(permission_name: "company_company_applied_student_list" , action_name: "applied_student_list" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_vacancy", remark: "/company/vacancy_applied_student_list/:id").save
Kodawarione::Permission.new(permission_name: "company_company_applied_job_approval_list" , action_name: "applied_job_approval_list" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_vacancy", remark: "/company/applied_job_approval_list").save

# Company MCompany Questionnaire
Kodawarione::Permission.new(permission_name: "company_mcompany_questionnaire_index" , action_name: "index" , permission_model_name: "Company::MCompanyQuestionnaire", permission_for: 4, permission_default_can: false, permission_group: "company_questionnaire", remark: "/company/assessments/[index,show]").save
Kodawarione::Permission.new(permission_name: "company_mcompany_questionnaire_questionnaire" , action_name: "questionnaire" , permission_model_name: "Company::MCompanyQuestionnaire", permission_for: 4, permission_default_can: true, permission_group: "company_questionnaire", remark: "/company/assessments/[new,create]").save
Kodawarione::Permission.new(permission_name: "company_mcompany_questionnaire_create" , action_name: "create" , permission_model_name: "Company::MCompanyQuestionnaire", permission_for: 4, permission_default_can: false, permission_group: "company_questionnaire", remark: "/company/assessments/:id/[edit,update]").save
Kodawarione::Permission.new(permission_name: "company_mcompany_questionnaire_update" , action_name: "update" , permission_model_name: "Company::MCompanyQuestionnaire", permission_for: 4, permission_default_can: false, permission_group: "company_questionnaire", remark: "/company/assessments/:id").save

# Company profiles
Kodawarione::Permission.new(permission_name: "company_company_home" , action_name: "home" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_profile", remark: "/company/commitment_profiles/home").save
Kodawarione::Permission.new(permission_name: "company_company_home_form" , action_name: "home_form" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_profile", remark: "/company/commitment_profiles/home_form").save
Kodawarione::Permission.new(permission_name: "company_company_about_us" , action_name: "about_us" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_profile", remark: "/company/commitment_profiles/about_us").save
Kodawarione::Permission.new(permission_name: "company_company_about_us_form" , action_name: "about_us_form" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_profile", remark: "/company/commitment_profiles/about_us_form").save
Kodawarione::Permission.new(permission_name: "company_company_recruitment" , action_name: "recruitment" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_profile", remark: "/company/commitment_profiles/recruitment").save
Kodawarione::Permission.new(permission_name: "company_company_recruitment_form" , action_name: "recruitment_form" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_profile", remark: "/company/commitment_profiles/recruitment_form").save
Kodawarione::Permission.new(permission_name: "company_company_member" , action_name: "member" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_profile", remark: "/company/commitment_profiles/member").save
Kodawarione::Permission.new(permission_name: "company_company_member_form" , action_name: "member_form" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_profile", remark: "/company/commitment_profiles/member_form").save
Kodawarione::Permission.new(permission_name: "company_company_create" , action_name: "create" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_profile", remark: "/company/companies/create").save
Kodawarione::Permission.new(permission_name: "company_company_update" , action_name: "update" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_profile", remark: "/company/companies/:id/update").save
# Kodawarione::Permission.new(permission_name: "company_company_destroy" , action_name: "destroy" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_profile", remark: "company permission url").save

# Company Commitment Ability
Kodawarione::Permission.new(permission_name: "company_company_commitment_ability_index" , action_name: "read" , permission_model_name: "Company::CompanyCommitmentAbility", permission_for: 4, permission_default_can: false, permission_group: "company_commitment_ability", remark: "/company/commitment_ability").save
## Kodawarione::Permission.new(permission_name: "company_company_commitment_ability_show" , action_name: "show" , permission_model_name: "Company::CompanyCommitmentAbility", permission_for: 4, permission_default_can: false, permission_group: "company_commitment_ability", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_company_commitment_ability_edit" , action_name: "update" , permission_model_name: "Company::CompanyCommitmentAbility", permission_for: 4, permission_default_can: false, permission_group: "company_commitment_ability", remark: "/company/commitment_ability/:id/[edit,update]").save
## Kodawarione::Permission.new(permission_name: "company_company_commitment_ability_update" , action_name: "update" , permission_model_name: "Company::CompanyCommitmentAbility", permission_for: 4, permission_default_can: false, permission_group: "company_commitment_ability", remark: "company permission url").save
# Kodawarione::Permission.new(permission_name: "company_company_commitment_ability_assessment" , action_name: "assessment" , permission_model_name: "Company::CompanyCommitmentAbility", permission_for: 4, permission_default_can: false, permission_group: "company_commitment_ability", remark: "/company/company_commitment/:id/assessment").save
# Kodawarione::Permission.new(permission_name: "company_company_commitment_ability_api_assessment" , action_name: "api_assessment" , permission_model_name: "Company::CompanyCommitmentAbility", permission_for: 4, permission_default_can: false, permission_group: "company_commitment_ability", remark: "/company/company_commitment/:id/api_assessment").save
# Kodawarione::Permission.new(permission_name: "company_company_commitment_ability_kodawari_assessment" , action_name: "kodawari_assessment" , permission_model_name: "Company::CompanyCommitmentAbility", permission_for: 4, permission_default_can: false, permission_group: "company_commitment_ability", remark: "/company/company_commitment/:id/assessment_commit").save

# Company Commitment
Kodawarione::Permission.new(permission_name: "company_company_commitment_show" , action_name: "read" , permission_model_name: "Company::CompanyCommitment", permission_for: 4, permission_default_can: false, permission_group: "company_commitment", remark: "/company/company_commitment/[show]").save
## Kodawarione::Permission.new(permission_name: "company_company_commitment_ability_show" , action_name: "show" , permission_model_name: "Company::CompanyCommitmentAbility", permission_for: 4, permission_default_can: false, permission_group: "company_commitment_ability", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_company_commitment_edit" , action_name: "update" , permission_model_name: "Company::CompanyCommitment", permission_for: 4, permission_default_can: false, permission_group: "company_commitment", remark: "/company/company_commitment/:id/[edit,update]").save

# Admin Event
Kodawarione::Permission.new(permission_name: "company_company_search_event", action_name: "search_event", permission_model_name: "Company::Search", permission_for: 4, permission_default_can: false, permission_group: "company_admin_event", remark: "/company/search_event").save
Kodawarione::Permission.new(permission_name: "event_join_participant" , action_name: "join_participant" , permission_model_name: "Company::AdminEvent", permission_for: 4, permission_default_can: false, permission_group: "company_admin_event", remark: "/company/admin_event_search/:id/join_participant").save
Kodawarione::Permission.new(permission_name: "event_join_admin_events" , action_name: "join_admin_events" , permission_model_name: "Company::AdminEvent", permission_for: 4, permission_default_can: false, permission_group: "company_admin_event", remark: "/company/join_admin_event/:id").save
Kodawarione::Permission.new(permission_name: "company_company_unjoin_event", action_name: "unjoin_event", permission_model_name: "Company::Search", permission_for: 4, permission_default_can: false, permission_group: "company_admin_event", remark: "/company/join_event_student_list/:id").save
Kodawarione::Permission.new(permission_name: "event_admin_event_list" , action_name: "admin_event_list" , permission_model_name: "Company::AdminEvent", permission_for: 4, permission_default_can: false, permission_group: "company_admin_event", remark: "/company/admin_event_list").save
Kodawarione::Permission.new(permission_name: "company_company_join_admin_event", action_name: "join_admin_event", permission_model_name: "Company::Search", permission_for: 4, permission_default_can: false, permission_group: "company_admin_event", remark: "/company/join_admin_event/:id").save
Kodawarione::Permission.new(permission_name: "company_company_admin_event_detail_search", action_name: "admin_event_detail_search", permission_model_name: "Company::Search", permission_for: 4, permission_default_can: false, permission_group: "company_admin_event", remark: "/company/admin_event_search/:id").save

# Company Student Matched Questionnnaire Result
Kodawarione::Permission.new(permission_name: "assessment_matched_result_index", action_name: "index" , permission_model_name: "AssessmentMatchedResult", permission_for: 4, permission_default_can: false, permission_group: "company_assessment_matched_result", remark: "/company/company_student_matched_questionnaire_result").save

# Company Student Matched Result
Kodawarione::Permission.new(permission_name: "company_company_student_matched_result_index", action_name: "index" , permission_model_name: "Company::CompanyStudentMatchedResult", permission_for: 4, permission_default_can: false, permission_group: "company_matched_result", remark: "/company/company_student_matched_result").save

# Company Dashboard
Kodawarione::Permission.new(permission_name: "company_company_index" , action_name: "index" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: true, permission_group: "company_home", remark: "/company/companies").save

# Company Scout
Kodawarione::Permission.new(permission_name: "company_company_scouted_result" , action_name: "scouted_result" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_scout", remark: "/company/scouted_result").save
Kodawarione::Permission.new(permission_name: "company_company_scouted_student_detail" , action_name: "scouted_student_detail" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_scout", remark: "/company/scouted_student_list/:mail_id/student_details/:student_id").save

# Company Login Information Change
Kodawarione::Permission.new(permission_name: "company_company_company_setting" , action_name: "company_setting" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: true, permission_group: "company_user_login_info", remark: "/company/company_setting").save
Kodawarione::Permission.new(permission_name: "company_company_company_setting_update" , action_name: "company_setting_update" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: true, permission_group: "company_user_login_info", remark: "/company/company_setting_update").save

# Partner News
Kodawarione::Permission.new(permission_name: "company_company_partner_news_index" , action_name: "partner_news_index" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_partner_news", remark: "/company/partner_news_company_index").save
Kodawarione::Permission.new(permission_name: "company_company_partner_news_detail" , action_name: "partner_news_detail" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_partner_news", remark: "/company/:id/partner_news_company_detail").save

# Student
Kodawarione::Permission.new(permission_name: "company_company_student_search", action_name: "student_search", permission_model_name: "Company::Search", permission_for: 4, permission_default_can: false, permission_group: "company_student", remark: "/company/students_search").save
Kodawarione::Permission.new(permission_name: "company_company_favourite_student", action_name: "favourite_student", permission_model_name: "Company::Search", permission_for: 4, permission_default_can: false, permission_group: "company_student", remark: "/company/favourite_student/:id").save
Kodawarione::Permission.new(permission_name: "company_company_favourite_student_index" , action_name: "favourite_student_index" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_student", remark: "/company/favourite_student_index").save
Kodawarione::Permission.new(permission_name: "company_company_favourite_student_list" , action_name: "favourite_student_list" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company_student", remark: "/company/favourite_student_list").save
Kodawarione::Permission.new(permission_name: "company_company_student_details", action_name: "student_details", permission_model_name: "Company::Search", permission_for: 4, permission_default_can: false, permission_group: "company_student", remark: "/company/student_details/:id").save

# Companies
Kodawarione::Permission.new(permission_name: "company_company_new" , action_name: "create" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: true, permission_group: "company", remark: "/company/companies/new").save
# Kodawarione::Permission.new(permission_name: "company_company_create" , action_name: "create" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_company_edit" , action_name: "update" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company", remark: "/company/companies/:id/edit").save
# Kodawarione::Permission.new(permission_name: "company_company_update" , action_name: "update" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company", remark: "company permission url").save
Kodawarione::Permission.new(permission_name: "company_company_destroy" , action_name: "destroy" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company", remark: "/company/companies/:id").save
Kodawarione::Permission.new(permission_name: "company_company_mail_settings" , action_name: "mail_settings" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: false, permission_group: "company", remark: "/company/mail_settings/:mail_setting").save
Kodawarione::Permission.new(permission_name: "company_company_company_genuine_password" , action_name: "company_genuine_password" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: true, permission_group: "company", remark: "/company/company_genuine_password").save
Kodawarione::Permission.new(permission_name: "company_company_company_genuine_password_change" , action_name: "company_genuine_password_change" , permission_model_name: "Company::Company", permission_for: 4, permission_default_can: true, permission_group: "company", remark: "/company/company_genuine_password_change/:confirmation_token").save



# Company
# Kodawarione::Permission.new(permission_name: "company_company_getLocationDetails", action_name: "getLocationDetails", permission_model_name: "Company::Search", permission_for: 4, permission_default_can: false, permission_group: "company_permission", remark: "company permission url").save
# Kodawarione::Permission.new(permission_name: "company_company_search_article", action_name: "search_article", permission_model_name: "Company::Search", permission_for: 4, permission_default_can: false, permission_group: "company_permission", remark: "company permission url").save
# Kodawarione::Permission.new(permission_name: "company_company_admin_event_detail_search", action_name: "admin_event_detail_search", permission_model_name: "Company::Search", permission_for: 4, permission_default_can: false, permission_group: "company_permission", remark: "company permission url").save
# Kodawarione::Permission.new(permission_name: "company_company_search_admin_article_detail", action_name: "search_admin_article_detail", permission_model_name: "Company::Search", permission_for: 4, permission_default_can: false, permission_group: "company_permission", remark: "company permission url").save 

