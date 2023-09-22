# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_10_06_033102) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_articles", force: :cascade do |t|
    t.string "title"
    t.string "video_link", array: true
    t.integer "show_option"
    t.boolean "delete_flg", default: false
    t.bigint "created_admin_id"
    t.bigint "updated_admin_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admin_contracts", force: :cascade do |t|
    t.bigint "admin_id"
    t.bigint "partner_id"
    t.date "start_date"
    t.date "end_date"
    t.date "training_start_date"
    t.date "training_end_date"
    t.bigint "admin_plan_id"
    t.bigint "payment_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admin_event_participants", force: :cascade do |t|
    t.bigint "admin_event_id"
    t.bigint "company_id"
    t.bigint "company_user_id"
    t.bigint "user_id"
    t.bigint "partner_id"
    t.bigint "partner_user_id"
    t.bigint "super_partner_id"
    t.bigint "super_partner_user_id"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_event_id"], name: "index_admin_event_participants_on_admin_event_id"
  end

  create_table "admin_events", force: :cascade do |t|
    t.bigint "admins_id"
    t.string "event_code"
    t.integer "category", array: true
    t.string "event_name"
    t.date "event_start_date"
    t.date "event_end_date"
    t.string "venue"
    t.date "post_start_date"
    t.integer "event_show_option"
    t.integer "admin_apply_event_limit"
    t.date "post_end_date"
    t.date "application_deadline"
    t.string "event_content"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admins_id"], name: "index_admin_events_on_admins_id"
  end

  create_table "admin_m_permission_types", force: :cascade do |t|
    t.string "permission_type"
    t.boolean "use_student", default: true
    t.boolean "use_company", default: true
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admin_members", force: :cascade do |t|
    t.bigint "admins_id", null: false
    t.bigint "admin_roles_id", null: false
    t.bigint "super_partners_id"
    t.bigint "partners_id"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_roles_id"], name: "index_admin_members_on_admin_roles_id"
    t.index ["admins_id"], name: "index_admin_members_on_admins_id"
    t.index ["partners_id"], name: "index_admin_members_on_partners_id"
    t.index ["super_partners_id"], name: "index_admin_members_on_super_partners_id"
  end

  create_table "admin_news", force: :cascade do |t|
    t.string "title"
    t.integer "news_type"
    t.string "other"
    t.boolean "delete_flg", default: false
    t.bigint "created_admin_id"
    t.bigint "updated_admin_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admin_permissions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "company_id"
    t.bigint "company_user_id"
    t.bigint "partner_id"
    t.bigint "partner_user_id"
    t.bigint "super_partner_id"
    t.bigint "super_partner_user_id"
    t.bigint "admin_permission_type_id"
    t.integer "user_type"
    t.string "create_user"
    t.cidr "ip_address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_permission_type_id"], name: "index_admin_permissions_on_admin_permission_type_id"
    t.index ["user_id"], name: "index_admin_permissions_on_user_id"
  end

  create_table "admin_plans", force: :cascade do |t|
    t.bigint "admin_id"
    t.string "name", limit: 100
    t.text "content"
    t.bigint "fee"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admin_roles", force: :cascade do |t|
    t.string "role_type"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "genuine_password", default: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "admin_code", limit: 20
    t.string "last_name", limit: 100
    t.string "first_name", limit: 100
    t.integer "user_type"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "questionnaire_id", null: false
    t.integer "answer_id", null: false
    t.string "comment"
    t.string "role"
    t.boolean "choice_flg", null: false
    t.boolean "delete_flg", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "api_access_tokens", force: :cascade do |t|
    t.string "token_type"
    t.string "token"
    t.string "name"
    t.integer "token_scope", array: true
    t.string "ip_address"
    t.boolean "delete_flg", default: false
    t.bigint "created_admin_id"
    t.bigint "updated_admin_id"
    t.datetime "last_used_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "application_status_transaction_details", force: :cascade do |t|
    t.bigint "application_status_transaction_id"
    t.integer "type_id"
    t.integer "status"
    t.integer "updated_user_role"
    t.integer "updated_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_status_transaction_id"], name: "application_status"
  end

  create_table "application_status_transactions", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "company_id"
    t.bigint "partner_id"
    t.bigint "company_vacancy_id"
    t.bigint "communication_id"
    t.integer "status"
    t.datetime "interview_date"
    t.string "interview_result"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["communication_id"], name: "index_application_status_transactions_on_communication_id"
    t.index ["company_id"], name: "index_application_status_transactions_on_company_id"
    t.index ["company_vacancy_id"], name: "index_application_status_transactions_on_company_vacancy_id"
    t.index ["partner_id"], name: "index_application_status_transactions_on_partner_id"
    t.index ["student_id"], name: "index_application_status_transactions_on_student_id"
  end

  create_table "apply_favourite_transictions", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "company_id"
    t.bigint "job_id"
    t.bigint "event_id"
    t.boolean "std_com_favourite", default: false, comment: " default = false, applied = true"
    t.boolean "std_job_favourite", default: false, comment: " default = false, applied = true"
    t.boolean "com_std_favourite", default: false, comment: " default = false, applied = true"
    t.boolean "std_job_apply", default: false, comment: " default = false, applied = true"
    t.boolean "event_favourite", default: false, comment: " default = false, applied = true"
    t.boolean "event_join", default: false, comment: " default = false, applied = true"
    t.date "action_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_apply_favourite_transictions_on_company_id"
    t.index ["student_id"], name: "index_apply_favourite_transictions_on_student_id"
  end

  create_table "assessment_matched_results", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "company_id", null: false
    t.string "role"
    t.float "matched_result", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_assessment_matched_results_on_company_id"
    t.index ["student_id"], name: "index_assessment_matched_results_on_student_id"
  end

  create_table "backup_dbs", force: :cascade do |t|
    t.string "name"
    t.string "backup_schedule"
    t.string "destroy_schedule"
    t.string "remark"
    t.string "file_type"
    t.string "backup_job_id"
    t.string "delete_job_id"
    t.date "delete_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "backup_details", force: :cascade do |t|
    t.bigint "backup_dbs_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "communication_details", force: :cascade do |t|
    t.bigint "communication_id"
    t.integer "sender_id"
    t.integer "receiver_id"
    t.string "content"
    t.integer "sent_type"
    t.integer "user_id"
    t.integer "company_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["communication_id"], name: "index_communication_details_on_communication_id"
  end

  create_table "communications", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.integer "sender_id"
    t.integer "receiver_id"
    t.string "content"
    t.integer "mail_type"
    t.integer "sent_type"
    t.integer "user_id"
    t.integer "company_user_id"
    t.bigint "company_id"
    t.integer "scout_status"
    t.datetime "scout_date"
    t.bigint "vacancy_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "companies", force: :cascade do |t|
    t.bigint "partner_id"
    t.string "company_name", limit: 255
    t.string "company_name_kana", limit: 255
    t.string "postal_code", limit: 10
    t.string "address", limit: 255
    t.string "display_address", limit: 255
    t.string "phone_no", limit: 20
    t.string "website_url", limit: 255
    t.bigint "m_industry_id"
    t.bigint "m_region_id"
    t.bigint "m_prefecture_id"
    t.string "postalcode_city"
    t.date "company_established"
    t.string "capital_amount"
    t.bigint "employee_count"
    t.string "sales_amount"
    t.text "related_company"
    t.text "main_bank"
    t.string "representative"
    t.text "contact"
    t.text "history"
    t.string "transportation_facilities"
    t.text "basic_idea"
    t.integer "mail_setting", default: 0
    t.string "contact_email", default: "", null: false
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.json "progress_details"
    t.boolean "progress_complete"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "company_activities", force: :cascade do |t|
    t.string "title"
    t.bigint "company_id", null: false
    t.boolean "delete_flg"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_activities_on_company_id"
  end

  create_table "company_commitment_abilities", force: :cascade do |t|
    t.string "status"
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_commitment_abilities_on_company_id"
  end

  create_table "company_commitment_ability_details", force: :cascade do |t|
    t.integer "ability_value"
    t.string "ability_reason"
    t.bigint "m_commitment_abilities_id", null: false
    t.bigint "company_id", null: false
    t.bigint "company_commitment_ability_id", null: false
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_commitment_ability_id"], name: "company_commitment_ability"
    t.index ["company_id"], name: "index_company_commitment_ability_details_on_company_id"
    t.index ["m_commitment_abilities_id"], name: "company_commitment_ability_id"
  end

  create_table "company_events", force: :cascade do |t|
    t.bigint "company_id"
    t.string "event_code"
    t.integer "category", array: true
    t.string "event_name"
    t.date "event_start_date"
    t.date "event_end_date"
    t.string "venue"
    t.date "post_start_date"
    t.date "post_end_date"
    t.date "application_start_date"
    t.date "application_deadline"
    t.string "event_content"
    t.integer "apply_event_limit"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_events_on_company_id"
  end

  create_table "company_interview_stories", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "company_id"
    t.string "title", limit: 200
    t.text "review"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_interview_stories_on_company_id"
    t.index ["user_id"], name: "index_company_interview_stories_on_user_id"
  end

  create_table "company_members", force: :cascade do |t|
    t.bigint "user_id"
    t.string "user_email"
    t.bigint "company_id"
    t.bigint "company_roles_id"
    t.bigint "created_userid"
    t.bigint "updated_userid"
    t.boolean "join_flag", default: false, comment: " default = false, joined = true"
    t.date "join_date"
    t.string "confirmation_token"
    t.string "department"
    t.string "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_company_members_on_user_id"
  end

  create_table "company_roles", force: :cascade do |t|
    t.bigint "company_id"
    t.string "role_type"
    t.string "remark"
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_roles_on_company_id"
  end

  create_table "company_student_matched_results", force: :cascade do |t|
    t.float "overall_result", null: false
    t.float "ability_1_percentage", null: false
    t.float "ability_2_percentage", null: false
    t.float "ability_3_percentage", null: false
    t.string "student_status"
    t.integer "student_id", null: false
    t.integer "company_id", null: false
    t.boolean "delete_flg", default: false, null: false
    t.json "result_details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "company_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_company_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_company_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_company_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_company_users_on_unlock_token", unique: true
  end

  create_table "company_vacancies", force: :cascade do |t|
    t.bigint "company_id"
    t.string "vacancy_title", limit: 255
    t.string "postal_code", limit: 255
    t.bigint "m_region_id"
    t.bigint "m_prefecture_id"
    t.string "postalcode_city"
    t.string "address", limit: 255
    t.string "display_address", limit: 255
    t.bigint "recruit_industry_type"
    t.bigint "recruit_job_type"
    t.integer "required_applicants"
    t.bigint "basic_salary"
    t.string "allowance"
    t.string "bonus"
    t.boolean "promotion"
    t.boolean "probation"
    t.boolean "transportation_allowance"
    t.boolean "dormitory"
    t.boolean "insurance"
    t.boolean "severance_pay"
    t.string "working_hours", limit: 255
    t.string "break_time", limit: 255
    t.boolean "over_time"
    t.string "other"
    t.string "hiring_flow_data", array: true
    t.string "holiday", limit: 255
    t.integer "welfare_list_data", array: true
    t.integer "company_enhancement", array: true
    t.date "display_from"
    t.date "display_to"
    t.string "other_skill", limit: 255
    t.boolean "published_flg"
    t.boolean "delete_flg", default: false
    t.bigint "created_user_id"
    t.bigint "updated_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_company_vacancies_on_company_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "classification"
    t.string "name"
    t.string "email"
    t.string "company_name"
    t.string "contact"
    t.text "content_inquiry"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.bigint "contract_from_id"
    t.bigint "contract_to_id"
    t.bigint "contract_role_type", comment: "admin=1, super_partner=2, partner=3"
    t.date "start_date"
    t.date "end_date"
    t.date "training_start_date"
    t.date "training_end_date"
    t.bigint "plan_id"
    t.bigint "payment_type"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "event_waits", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "join_user_type", comment: " company=1, student=2, partner=3, admin=4 , super_partner=5"
    t.bigint "user_id"
    t.bigint "company_id"
    t.bigint "company_user_id"
    t.bigint "partner_id"
    t.bigint "partner_user_id"
    t.bigint "super_partner_id"
    t.bigint "super_partner_user_id"
    t.date "join_date"
    t.bigint "approver_user_type", comment: " company=1, student=2, partner=3, admin=4 , super_partner=5"
    t.bigint "approver_id"
    t.bigint "approver_user_id"
    t.date "approve_date"
    t.boolean "join_flg", default: false
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "event_code"
    t.bigint "created_by_id", comment: "company_id, partner_id and admin_id"
    t.string "event_name"
    t.integer "venue_types"
    t.string "venue"
    t.integer "category", array: true
    t.integer "event_show_option"
    t.integer "apply_event_limit"
    t.bigint "created_user_id"
    t.integer "event_type", comment: " company=1, partner=2, admin=3 , super_partner=4"
    t.date "event_start_date"
    t.date "event_end_date"
    t.date "post_start_date"
    t.date "post_end_date"
    t.date "application_start_date"
    t.date "application_deadline"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "logout_histories", force: :cascade do |t|
    t.bigint "company_user_id"
    t.bigint "company_id"
    t.integer "active_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_user_id"], name: "index_logout_histories_on_company_user_id"
  end

  create_table "m_commitment_abilities", force: :cascade do |t|
    t.string "name", comment: "select the type of ability on screen"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_company_questionnaires", force: :cascade do |t|
    t.string "questionnaire_title", null: false
    t.string "questionnaire_content", null: false
    t.integer "basic_point"
    t.integer "stages"
    t.boolean "delete_flg", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_industries", force: :cascade do |t|
    t.string "industry_name", comment: "select the type of industry on screen"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_occupations", force: :cascade do |t|
    t.string "occupation_name", comment: "select the type of occupation name on screen"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_prefectures", force: :cascade do |t|
    t.bigint "m_region_id"
    t.string "prefecture_name", comment: "select the type of List of prefecture denpen on region"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["m_region_id"], name: "index_m_prefectures_on_m_region_id"
  end

  create_table "m_qualification_details", force: :cascade do |t|
    t.bigint "m_qualification_id"
    t.string "qualification_type", comment: "select the type of List of qualification denpen on qualification type"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["m_qualification_id"], name: "index_m_qualification_details_on_m_qualification_id"
  end

  create_table "m_qualifications", force: :cascade do |t|
    t.string "qualification_category", comment: "select the type of qualification List on screen"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_regions", force: :cascade do |t|
    t.string "region_name", comment: "select the type of region on screen"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_student_questionnaires", force: :cascade do |t|
    t.string "questionnaire_title", null: false
    t.string "questionnaire_content", null: false
    t.integer "basic_point"
    t.integer "stages"
    t.boolean "delete_flg", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "m_welfare_details", force: :cascade do |t|
    t.bigint "m_welfare_id"
    t.string "welfare_type", comment: "select the type of List of benefits denpen on welfares type"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["m_welfare_id"], name: "index_m_welfare_details_on_m_welfare_id"
  end

  create_table "m_welfares", force: :cascade do |t|
    t.string "welfare_category", comment: "select the type of List of benefits or welfares on screen"
    t.boolean "delete_flag", default: false, comment: " default = false, deleted = true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mail_template_registrations", force: :cascade do |t|
    t.bigint "company_id"
    t.string "template_name"
    t.string "subject"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_mail_template_registrations_on_company_id"
  end

  create_table "news", force: :cascade do |t|
    t.string "title"
    t.integer "news_type", comment: "admin=1, super_partner=2, partner=3"
    t.bigint "created_by_id", comment: "admin_id, super_partner_id, partner_id"
    t.integer "news_category", comment: ", other=1, important=2, usually=3"
    t.string "other"
    t.integer "show_option", comment: "super_partner=1, partner=2, company=3, student=4", array: true
    t.bigint "created_user_id"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "record_type"
    t.bigint "record_id"
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.bigint "sent_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "partners", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "partner_code", limit: 10
    t.bigint "super_partner_id"
    t.string "postal_code", limit: 10
    t.string "address", limit: 255
    t.string "display_address", limit: 255
    t.string "phone_no", limit: 20
    t.string "website_url", limit: 255
    t.string "postalcode_city"
    t.bigint "m_region_id"
    t.bigint "m_prefecture_id"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string "permission_name"
    t.string "action_name"
    t.string "permission_model_name"
    t.integer "permission_for"
    t.boolean "permission_default_can"
    t.string "permission_group"
    t.string "remark"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "plans", force: :cascade do |t|
    t.bigint "plan_role_type", comment: "admin=1, super_partner=2, partner=3"
    t.bigint "created_id", comment: "admin_id, super_partner_id, partner_id"
    t.string "name", limit: 100
    t.text "content"
    t.bigint "fee"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pre_calculated_ability_results", force: :cascade do |t|
    t.integer "ability_1_id"
    t.integer "ability_2_id"
    t.float "matched_percentage"
    t.float "original_matched_result"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questionnaire_answers", force: :cascade do |t|
    t.integer "questionnaire_id", null: false
    t.string "questionnaire_answer", null: false
    t.boolean "delete_flg", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "role_permissions", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "permission_id"
    t.boolean "can"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "student_assessments", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.string "appeal_point_title_1"
    t.text "appeal_point_article_1"
    t.string "appeal_point_title_2"
    t.text "appeal_point_article_2"
    t.string "appeal_point_title_3"
    t.text "appeal_point_article_3"
    t.integer "logical_and_rational", array: true
    t.integer "solid_and_planned", array: true
    t.integer "sensory_and_friendly", array: true
    t.integer "adventurous_and_original", array: true
    t.integer "love_and_desire_to_belong", array: true
    t.integer "desire_for_power_and_value", array: true
    t.integer "desire_for_freedom", array: true
    t.integer "desire_for_fun", array: true
    t.integer "desire_for_survival", array: true
    t.integer "self_expression", array: true
    t.integer "self_assertion", array: true
    t.integer "self_flexibility", array: true
    t.integer "first_priority_language"
    t.integer "second_priority_language"
    t.integer "third_priority_language"
    t.integer "english_qualification"
    t.integer "toefl_test"
    t.integer "toeic_test"
    t.date "brain_action_date"
    t.date "potential_action_date"
    t.date "behavioral_action_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["student_id"], name: "index_student_assessments_on_student_id"
  end

  create_table "student_commitment_abilities", force: :cascade do |t|
    t.string "status"
    t.bigint "student_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["student_id"], name: "index_student_commitment_abilities_on_student_id"
  end

  create_table "student_commitment_ability_details", force: :cascade do |t|
    t.integer "ability_value"
    t.string "ability_reason"
    t.bigint "m_commitment_abilities_id", null: false
    t.bigint "student_id", null: false
    t.bigint "student_commitment_ability_id", null: false
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["m_commitment_abilities_id"], name: "student_commitment_ability_id"
    t.index ["student_commitment_ability_id"], name: "student_commitment_ability"
    t.index ["student_id"], name: "index_student_commitment_ability_details_on_student_id"
  end

  create_table "student_company_matched_results", force: :cascade do |t|
    t.float "overall_result", null: false
    t.float "ability_1_percentage", null: false
    t.float "ability_2_percentage", null: false
    t.float "ability_3_percentage", null: false
    t.string "company_status"
    t.integer "student_id", null: false
    t.integer "company_id", null: false
    t.json "result_details"
    t.boolean "delete_flg", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "students", force: :cascade do |t|
    t.bigint "user_id"
    t.string "nick_name"
    t.string "last_name", limit: 100
    t.string "first_name", limit: 100
    t.string "last_name_kana", limit: 100
    t.string "first_name_kana", limit: 100
    t.integer "gender"
    t.date "birthday"
    t.string "email_two"
    t.boolean "delete_flg", default: false
    t.string "postal_code", limit: 255
    t.bigint "postal_region_id"
    t.bigint "postal_prefecture_id"
    t.string "postalcode_city"
    t.string "address", limit: 255
    t.string "display_address", limit: 255
    t.string "phone_no", limit: 20
    t.integer "school_type"
    t.string "school_name"
    t.string "department_name"
    t.integer "subject_system"
    t.string "graduation_date"
    t.integer "desire_industry_type_id", array: true
    t.integer "desire_job_type_id", array: true
    t.integer "m_region_id"
    t.integer "m_prefecture_id", array: true
    t.integer "qualification_category_id", array: true
    t.integer "qualification_type_id", array: true
    t.string "club_name"
    t.string "club_position"
    t.string "club_detail_activity"
    t.integer "outside_school_activity", array: true
    t.string "club_guide"
    t.boolean "is_beelab_activity_participate", comment: "deleted = true"
    t.string "beelab_college_achievements"
    t.string "attachment_for_pr"
    t.string "sns_blog_for_pr"
    t.string "pando_info"
    t.string "job_info"
    t.bigint "current_address"
    t.integer "preferred_working_area", array: true
    t.string "commitment", limit: 255
    t.string "cover_color", limit: 100
    t.string "qualification_string", limit: 255
    t.json "progress_details"
    t.boolean "progress_complete"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "super_partners", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "super_partner_code", limit: 10
    t.string "postal_code", limit: 10
    t.string "address", limit: 255
    t.string "display_address", limit: 255
    t.string "phone_no", limit: 20
    t.string "website_url", limit: 255
    t.string "postalcode_city"
    t.bigint "m_region_id"
    t.bigint "m_prefecture_id"
    t.boolean "delete_flg", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.bigint "partner_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "delete_flg", default: false
    t.string "provider"
    t.string "uid"
    t.string "jti"
    t.string "contact_person_first_name", limit: 255
    t.string "contact_person_last_name", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vacancy_apply_favourites", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "company_id"
    t.bigint "company_vacancy_id"
    t.boolean "apply_flg", default: false
    t.boolean "favourite_flg", default: false
    t.date "apply_date"
    t.date "favourite_date"
    t.integer "apply_status"
    t.date "apply_status_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_vacancy_apply_favourites_on_company_id"
    t.index ["company_vacancy_id"], name: "index_vacancy_apply_favourites_on_company_vacancy_id"
    t.index ["student_id"], name: "index_vacancy_apply_favourites_on_student_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_members", "admin_roles", column: "admin_roles_id"
  add_foreign_key "admin_members", "admins", column: "admins_id"
  add_foreign_key "admin_members", "partners", column: "partners_id"
  add_foreign_key "admin_members", "super_partners", column: "super_partners_id"
  add_foreign_key "assessment_matched_results", "companies"
  add_foreign_key "assessment_matched_results", "students"
  add_foreign_key "company_commitment_abilities", "companies"
  add_foreign_key "company_commitment_ability_details", "companies"
  add_foreign_key "company_commitment_ability_details", "company_commitment_abilities"
  add_foreign_key "company_commitment_ability_details", "m_commitment_abilities", column: "m_commitment_abilities_id"
  add_foreign_key "company_vacancies", "companies"
  add_foreign_key "student_assessments", "students"
  add_foreign_key "student_commitment_abilities", "students"
  add_foreign_key "student_commitment_ability_details", "m_commitment_abilities", column: "m_commitment_abilities_id"
  add_foreign_key "student_commitment_ability_details", "student_commitment_abilities"
  add_foreign_key "student_commitment_ability_details", "students"
end
