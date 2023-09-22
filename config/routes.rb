Rails.application.routes.draw do
  namespace :communication do
    resources :communications, only: %i[index new create show]
    resources :communication_details, only: %i[new create]
    resources :mail_template_registrations
    get 'partner_index',to: 'communications_partner#partner_index', as: 'partner_index'
    get 'student_communication',to: 'communications_partner#student_communication'
    get 'kodawarione_user_communication',to: 'communication_kodawarione#kodawarione_user_communication'
    get 'kodawarione_company_communication',to: 'communication_kodawarione#kodawarione_company_communication'
    get 'company_communication',to: 'communications_partner#company_communication'
    get 'spu_company_communication',to: 'communications_spu#spu_company_communication'
    get 'spu_student_communication',to: 'communications_spu#spu_student_communication'
    get 'admin_company_communication',to: 'communications_admin#admin_company_communication'
    get 'admin_student_communication',to: 'communications_admin#admin_student_communication'
    # conversation row click
    get 'conversation_forum/:id', to: 'communications#conversation_forum', as: 'conversation_forum'
    get 'direct_message_conversation_details',to: 'communications#direct_message_conversation_details', as: 'direct_conversation_details'
    get 'scott_message_conversation_details',to: 'communications#scott_message_conversation_details', as: 'scott_conversation_details'
    get 'new_communicate_list', to: 'communications#new_communicate_list', as: 'new_communicate_list'
    post 'create_with_multiple_users', to: 'communications#create_with_multiple_users', as: 'create_with_multiple_users'
    # get scout_mail confirmation
    get 'scout_mail_accept/:id', to: 'communications#scout_mail_accept', as: 'scout_mail_accept'
    get 'scout_mail_reject/:id', to: 'communications#scout_mail_reject', as: 'scout_mail_reject'
    # ajax call for mail template change
    get 'template_change', to: 'communications#template_change'
  end
  get 'rails/g'
  get 'rails/controller'
  # For admin sing_in
  get 'bl-admin', as: 'bl-admin', to: 'admin/dashboard#admin'

  # commons Controller
  scope ':scop_name' do
    get 'user_setting', to: 'commons#user_setting'
    get 'genuine_password', to: 'commons#genuine_password'
  end
  patch 'genuine_password_change/:confirmation_token', to: 'commons#genuine_password_change',
                                                       as: 'genuine_password_change'
  patch 'user_setting_update', to: 'commons#user_setting_update'
  get 'user_setting_update', to: 'commons#user_setting'
  get 'get_region_name_by_prefecturename/:name', to: 'commons#get_region_name_by_prefecturename'

  get 'user_page/:id', as: 'user_page', to: 'commons#change_user_page'

  namespace :welcome do
    get 'welcomes/index', as: 'index'
    get 'student', as: 'student', to: 'welcomes#student_index'
    get 'company', as: 'company', to: 'welcomes#company_index'
    get 'contact', as: 'contact', to: 'welcomes#contact_index'
    get 'privacy', as: 'privacy', to: 'welcomes#privacy_index'
    get 'event', as: 'event', to: 'welcomes#event_index'
    get 'term_condition', as: 'term_condition', to: 'welcomes#term_condition_index'
    get 'registration_complete', as: 'registration_complete', to: 'welcomes#registration_complete'
    post 'contact_create', as: 'contact_create', to: 'welcomes#contact_create'
    get 'contact_create', to: 'welcomes#contact_index'
    get 'student_login', as: 'student_login', to: 'welcomes#student_login'
    get 'student_register', as: 'student_register', to: 'welcomes#student_register'
    get 'company_login', as: 'company_login', to: 'welcomes#company_login'
    get 'company_register', as: 'company_register', to: 'welcomes#company_register'
  end

  namespace :company do
    # GET event apply list
    get 'event_apply_list/:id', to: 'events#event_apply_list', as: "event_apply_list"
    resources :companies, only: %i[index new edit update create]
    # get company edit
    get 'companies/:id', to: 'companies#edit'
    resources :vacancies, only: %i[index new edit update create show]
    resources :assessments, only: %i[index update create]
    get 'questionnaire', to: 'assessments#questionnaire', defaults: { format: :json }
    resources :events
    resources :admin_events, only: %i[new]
    get 'admin_event_search/:id/join_participant', to: 'admin_events#join_participant', as: 'admin_event_search_join_participant'
    resources :company_commitment, only: %i[edit show update]
    resources :activities
    # begind::Company Event
    post "create", to: 'events#create'
    post "company_event_update/:id", to: 'events#update', as: "event_update"
    delete "company_event_delete", to: "events#destroy", as: "event_destroy"
    resources :company_members
    resources :commitment_profiles do
      collection do
        get 'home', to: 'commitment_profiles#home'
        get 'home_form', to: 'commitment_profiles#home_form'
        get 'about_us', to: 'commitment_profiles#about_us'
        get 'about_us_form', to: 'commitment_profiles#about_us_form'
        get 'recruitment', to: 'commitment_profiles#recruitment'
        get 'recruitment_form', to: 'commitment_profiles#recruitment_form'
        get 'member', to: 'commitment_profiles#member'
        get 'member_form', to: 'commitment_profiles#member_form'
      end
    end
    resources :interview_stories

    #company accept/reject
    get 'apply_accept/:id', to: 'vacancies#apply_accept', as: 'apply_accept'
    get 'apply_reject/:id', to: 'vacancies#apply_reject', as: 'apply_reject'
    #vacancy apply list for apply/reject
    get 'vacancy_applied_student_list/:id', to: 'vacancies#vacancy_applied_student_list', as: 'vacancy_applied_student_list' 
    #student detail from apply list
    get 'vacancy_applied_student_list/:vacancy_id/student_details/:student_id', to: 'vacancies#vacancy_applied_student_detail', as: 'vacancy_applied_student_detail'
    #company scout result list
    get 'scouted_result', to: 'companies#scouted_result'
    #student detail from company scout result list
    get 'scouted_student_list/:mail_id/student_details/:student_id', to: 'companies#scouted_student_detail', as: 'scouted_student_detail'
    #get company member confirmation
    get 'company_member_confirmation', to: 'company_members#company_member_confirmation'
    get 'company_member_accept', to: 'company_members#company_member_accept'
    get 'company_member_reject', to: 'company_members#company_member_reject'
    # Student Search and Detail
    get 'students_search', to: 'search#student_search'
    get 'student_details/:id', to: 'search#student_details', as: 'student_details'
    get 'favourite_student/:id', to: 'search#favourite_student', as: 'favourite_student'
    get 'join_admin_event/:id', to: 'search#join_admin_event'
    get 'getLocationDetails', to: 'search#getLocationDetails'
    get 'favourite_student_index', to: 'companies#favourite_student_index'
    get 'favourite_student_list', to: 'companies#favourite_student_list', as: 'favourite_student_list'
    get 'applied_student_list', to: 'companies#applied_student_list', as: 'applied_student_list'
    get 'applied_job_approval_list', to: 'companies#applied_job_approval_list', as: 'applied_job_approval_list'
    get 'search_article', to: 'search#search_article'
    get 'search_admin_article_detail', to: 'search#search_admin_article_detail'
    get 'unjoin_event/:student_id/:event_id', to: 'search#unjoin_event'
    # Event controller
    get 'select_past_events', to: 'events#select_past_events'
    # Event Search Page those are created by admin
    # set mail setting
    get 'mail_settings/:mail_setting', to: 'companies#mail_settings'
    # admin-event view,update,delete -> those are created by admin
    post 'update_admin_event_joined', to: 'admin_events#update_admin_event_joined', as: 'update_admin_event_joined'

    #Join admin_events those are created by admin
    post "join_admin_events", to: "admin_events#join_admin_events", as: "join_admin_events"
    get "admin_event_list", to: "admin_events#admin_event_list"
    
    get 'search_event', to: 'search#search_event'
    get "admin_event_search/:id", to: "search#admin_event_detail_search", as: "admin_event_detail_search"
    
    get 'company_setting', to: 'companies#company_setting', as: 'setting'
    get 'company_setting_update', to: 'companies#company_setting'
    patch 'company_setting_update', to: 'companies#company_setting_update', as: 'setting_update'
    get 'company_genuine_password', to: 'companies#company_genuine_password', as: 'genuine_password'
    patch 'company_genuine_password_change/:confirmation_token', to: 'companies#company_genuine_password_change',
                                                         as: 'genuine_password_change'
    #Company Commitment - Kodawari Assessment                                                   
    # get 'company_commitment/:id/assessment', to: 'company_commitment#assessment', as: 'company_commitment_assessment'
    # get 'company_commitment/:id/assessment_commit', to: 'company_commitment#kodawari_assessment', as: 'commitment_kodawari_assessment'
    # get 'company_commitment/:id/api_assessment', to: 'company_commitment#api_assessment', defaults: { format: :json }

    # Partner News List
    get 'partner_news_company_index', to: 'companies#partner_news_index'
    get ':id/partner_news_company_detail', to: 'companies#partner_news_detail', as: 'partner_news_company_detail'

    # company student matched result
    get 'company_student_matched_result', to: 'company_student_matched_result#index'

    # company student matched result
    get 'company_student_matched_questionnaire_result', to: 'company_student_matched_questionnaire_result#index'
    
    # company commitment ability
    resources :commitment_ability, only: %i[index update create]
    get 'commitment_ability_start', to: 'commitment_ability#show'
  end

  namespace :student do
    resources :students, only: %i[index edit update create]
    resources :assessments, only: %i[index update create]
    resources :student_commitment, only: %i[index edit update create]
    resources :commitment_steps
    get 'student_commitment/:id', to: 'student_commitment#edit'
    get 'students/:id', to: 'students#edit'
    get 'user_confirm_member', to: 'students#user_confirm_member'
    get 'profile_detail', to: 'students#profile_detail'
    get 'students/:id/new_profile_edit', to: 'students#new_profile_edit'
    get 'student_smart_brain_diagnosis', to: 'assessments#student_smart_brain_diagnosis'
    get 'student_potential_desire_type_diagnosis', to: 'assessments#student_potential_desire_type_diagnosis'
    get 'student_behavioral_trait_type', to: 'assessments#student_behavioral_trait_type'
    #student scout result list
    get 'scouted_result', to: 'students#student_scouted_result'
    # company Search and Detail
    get 'companies_search', to: 'search#company_search'
    get 'favourite_company/:id', to: 'search#favourite_company'
    # Seach Vacancy and Detail
    get 'vacancy_search', to: 'search#vacancy_search'
    get 'search_vacancy_detail/:id', to: 'search#search_vacancy_detail', as: 'vacancy_details'
    get 'favourite_vacancy/:id', to: 'search#favourite_vacancy'
    get 'apply_vacancy/:id', to: 'search#apply_vacancy'
    # Search Event
    get 'search_event', to: 'search#search_event'
    get 'search_past_event', to: 'search#search_past_event'
    get 'search_event_detail/:id', to: 'search#search_event_detail', as: 'event_details'
    get 'favourite_event/:id', to: 'search#favourite_event'
    get 'join_event/:id', to: 'search#join_event'
    get 'join_event_search_detail/:id', to: 'search#join_event_search_detail', as: 'join_event_search_detail'
    #Event Search Page those are created by admin
    get "admin_event_search", to: "search#admin_event_search"
    get "admin_event_search_params", to: "search#admin_event_search_params"
    get "admin_event_search/:id", to: "search#admin_event_detail_search", as: "admin_event_detail_search"
    get 'admin_join_event/:id', to: 'search#admin_join_event'

    get 'prefecture_name/:id', to: 'students#prefecture_name'
    get 'favourite_company_index', to: 'students#favourite_company_index'
    get 'favourite_vacancy_index', to: 'students#favourite_vacancy_index'
    get 'applied_vacancy_index', to: 'students#applied_vacancy_index'
    get 'favourite_event_index', to: 'students#favourite_event_index'
    get 'join_event_index', to: 'students#join_event_index'
    get 'joined_admin_event_index', to: 'students#joined_admin_event_index'

    get 'student_search_article', to: 'search#student_search_article', as: 'search_article'
    get 'search_student_article_detail', to: 'search#search_student_article_detail', as: 'search_article_detail'

    # Story Details
    get 'search_story_detail/:id', to: 'search#search_story_detail', as: 'story_details'

    # Partner News List
    get 'partner_news_index', to: 'students#partner_news_index'
    get ':id/partner_news_detail', to: 'students#partner_news_detail', as: 'partner_news_detail'

    # get 'student_commitment/:id/api_assessment', to: 'company_commitment#api_assessment', defaults: { format: :json }

    # student commitment ability
    resources :commitment_ability, only: %i[index update create]
    get 'commitment_ability_start', to: 'commitment_ability#show'

    # student company matched result
    get 'student_company_matched_result', to: 'student_company_matched_result#index'

    # student company matched result
    get 'student_company_matched_questionnaire_result', to: 'student_company_matched_questionnaire_result#index'

    # student questionarie assessment
    resources :questionnarie_assessments
    get 'questionnaire', to: 'questionnarie_assessments#index'
    get 'api/questionnaire', to: 'questionnarie_assessments#questionnaire', defaults: { format: :json }
  end

  devise_for :users, path: 'users',
                     controllers: { sessions: 'users/sessions', passwords: 'users/passwords', registrations: 'users/registrations', confirmations: 'users/confirmations',
                                    omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get '/logout', to: 'users/sessions#destroy', as: :logout
    get 'users', to: 'welcome/welcomes#index'
    get 'users/password', to: 'welcome/welcomes#index'
    get 'sign_in_sign_up', to: 'users/sessions#sign_in_sign_up'
    post 'check_user_mail', to: 'users/sessions#check_user_mail'
    # get 'auth/facebook/callback'  => 'users/omniauth_callbacks#facebook'
  end

  devise_for :company_users, path: 'company_users',
                     controllers: { sessions: 'company_users/sessions', passwords: 'company_users/passwords', registrations: 'company_users/registrations', confirmations: 'company_users/confirmations' }

  devise_scope :company_user do
    get 'company_user_logout', to: 'company_users/sessions#destroy', as: :company_user_logout
    get 'company_users', to: 'welcome/welcomes#index'
    get 'company_users/password', to: 'welcome/welcomes#index'
  end

  devise_for :admins, path: 'admins',
                      controllers: { sessions: 'admin/admins/sessions', passwords: 'admin/admins/passwords', confirmations: 'admin/admins/confirmations' }
  devise_scope :admins do
    get 'sign_in', to: 'admin/admins/sessions#new'
    get 'logout', to: 'admin/admins/sessions#destroy'
  end
  
  namespace :admin do
    get 'event/index'
    get 'admin/event/new' , to: "event#new"
    post 'create' , to: "event#create"
    get 'admin/event/details' , to: "event#admin_event_details"
    # Admin Event Participants
    get 'super_partner_participants_search', to: 'event#super_partner_participants_search'
    get 'super_partner_participants_details', to: 'event#super_partner_participants_details'
    get 'partner_user_event_participants_search', to: 'event#partner_user_event_participants_search'
    get 'partner_participant_details', to: 'event#partner_participant_details'
    get 'event_participants_search', to: 'event#event_participants_search'
    get 'user_event_participants_search', to: "event#user_event_participants_search"
    get 'event_participants_details', to: 'event#event_participants_details'
    get 'event/admin_event_edit', to: "event#admin_event_edit"
    post 'event/admin_event_update/:id', to: "event#admin_event_update", as: "event_update"
    get 'event/admin_event_delete', to: "event#admin_event_delete"

    get 'dashboard/index'
    get 'password_change', to: 'commons#admin_password_change'
    post 'password_update', to: 'commons#password_update'
    get 'admin_student_setting', to: 'student_manage/student#admin_student_setting'
    get 'admin_company_setting', to: 'company_manage/company#admin_company_setting'
    get 'company_user_lists', to: 'company_manage/company#company_user_lists'
    get 'company_user_set_permission/:type_id/:company_user_id/:company_id', to: 'company_manage/company#company_user_set_permission'

    resources :super_partner_users
    resources :super_partners
    resources :backup_db
    resources :news
    resources :articles
    resources :admin_plans
    resources :admin_contracts
    resources :api_access_tokens
    resources :partners
    resources :partner_users
    resources :admin_users
    get 'new_genuie_password', to: 'admin_users#new_genuie_password', as: 'genuie_password'
    patch 'create_genuie_password/:confirmation_token', to: 'admin_users#create_genuie_password', as: 'genuie_password_change'

    namespace :super_partner_manage do
      # super partner events
      get 'event_search', to: 'event#index'
      get 'event_details', to: 'event#event_details'
      get 'event_edit', to: 'event#event_edit'
      post 'event_update/:id', to: 'event#event_update', as: 'event_update'
      get 'event_delete', to: 'event#event_delete'
      #begin::super partner admin setting
      get 'admin_super_partner_setting', to: 'super_partner#admin_super_partner_setting'
      get 'super_partner_user_lists', to: 'super_partner#super_partner_user_lists'
      get 'super_partner_user_set_permission/:type_id/:super_partner_user_id/:super_partner_id', to: 'super_partner#super_partner_user_set_permission'
      get 'set_permission/:type_id/:super_partner_id', to: 'super_partner#set_permission'
      #end::super partner admin setting
    end

    namespace :partner_manage do
      get 'partner_event_search', to: 'event#index'
      get 'partner_event_details', to: 'event#event_details'
      get 'partner_event_edit', to: 'event#event_edit'
      post 'partner_event_update/:id', to: 'event#event_update', as: 'partner_event_update'
      get 'partner_event_delete', to: 'event#event_delete'
      #begin::super partner admin setting
      get 'admin_partner_setting', to: 'partner#admin_partner_setting'
      get 'partner_user_lists', to: 'partner#partner_user_lists'
      get 'partner_user_set_permission/:type_id/:partner_user_id/:partner_id', to: 'partner#partner_user_set_permission'
      get 'set_permission/:type_id/:partner_id', to: 'partner#set_permission'
      #end::super partner admin setting
    end

    namespace :student_manage do
      # Admin Student
      get 'student_search', to: 'student#student_search'
      get 'student_details', to: 'student#student_details'
      get 'student_edit', to: 'student#student_edit'
      get 'student_delete', to: 'student#student_delete'
      post 'student_update/:id', to: 'student#student_update'
      get 'admin_favourite_student', to: 'student#admin_favourite_student'
      get 'set_permission/:type_id/:user_id', to: 'student#set_permission'
    end
    namespace :company_manage do
      # Admin Company
      get 'company_search', to: 'company#company_search'
      get 'company_details', to: 'company#company_details'
      get 'company_edit', to: 'company#company_edit'
      post 'company_update/:id', to: 'company#company_update', as: 'company_update'
      get 'company_delete', to: 'company#company_delete'
      get 'favourite_company', to: 'company#favourite_company'
      get 'set_permission/:type_id/:company_id', to: 'company#set_permission'

      # Admin Event
      get 'event_search', to: 'events#event_search'
      get 'event_details', to: 'events#event_details'
      get 'event_edit', to: 'events#event_edit'
      post 'event_update/:id', to: 'events#event_update', as: 'event_update'
      get 'event_delete', to: 'events#event_delete'

      # Admin Vacancy
      get 'vacancy_search', to: 'vacancies#vacancy_search'
      get 'vacancy_details', to: 'vacancies#vacancy_details'
      get 'vacancy_edit', to: 'vacancies#vacancy_edit'
      post 'vacancy_update/:id', to: 'vacancies#vacancy_update', as: 'vacancy_update'
      get 'vacancy_delete', to: 'vacancies#vacancy_delete'
    end
  end

  ################################################################
  # Kodawarione Admin, Super Partner, Partner Application Routes
  ################################################################
  namespace :kodawarione do
    get 'dashboard/index'
    get 'event_list', to: 'event#event_list' 
    get 'news_noti_index', to: 'dashboard#news_noti_index'
    get ':id/news_noti_detail', to: 'dashboard#news_noti_detail', as:'news_noti_detail'
    get 'show/:id', to: 'event#show'
    get 'new', to: 'event#new'
    post 'create' , to: 'event#create'
    get 'event_edit', to: 'event#event_edit'
    post "admin_self_event_update/:id", to: 'event#admin_self_event_update', as: 'admin_self_event_update'
    delete 'admin_self_event_delete', to: 'event#admin_self_event_delete'
    get 'event_joined_by_user', to: "event#event_joined_by_user"
    get 'event_joined_by_spu', to: "event#event_joined_by_spu"
    get 'event_joined_by_partner', to: "event#event_joined_by_partner"
    get 'event_joined_by_company', to: "event#event_joined_by_company"
    
    resources :kodawari_roles
    resources :news
    resources :plans
    resources :contracts
    resources :permissions

    resources :admin_roles, only: %i[index new update create show edit destroy]
    get 'permission_data', to: 'admin_roles#permission_data'
    get 'permission_categories', to: 'admin_roles#permission_categories'
    post 'save_role_permission', to: 'admin_roles#save_role_permission'

    resources :company_roles, only: %i[index new update create show edit destroy]
    get 'company_permission_data', to: 'company_roles#permission_data'
    get 'company_permission_categories', to: 'company_roles#permission_categories'
    post 'company_save_role_permission', to: 'company_roles#save_role_permission'

    namespace :super_partner_manage do
      get 'index', to: 'super_partners#index'
      get 'super_partner_details/:id', to: 'super_partners#super_partner_details', as: 'super_partner_details'
      get 'super_partner_details/edit/:id', to: 'super_partners#edit_super_partner_details', as: 'edit_super_partner_details'
      post 'super_partner_details/update/:id', to: 'super_partners#update_super_partner_details', as: 'update_super_partner_details'
      get 'super_partner_details/:id/member_list',to: 'super_partners#super_partner_member_list', as: 'super_partner_member_list'
      get 'super_partner_details/:id/member_setup/new',to: 'super_partners#new_super_partner_member_setup', as: 'new_super_partner_member_setup'
      post 'super_partner_details/:id/member_setup/create',to: 'super_partners#create_super_partner_member_setup', as: 'create_super_partner_member_setup'
      get 'super_partner_details/:super_partner_id/member_setup/:id',to: 'super_partners#show_super_partner_member_setup', as: 'show_super_partner_member_setup'
      get 'super_partner_details/:super_partner_id/member_setup/edit/:id', to: 'super_partners#edit_super_partner_member_setup', as: 'edit_super_partner_member_setup'
      post 'super_partner_details/:super_partner_id/member_setup/update/:id', to: 'super_partners#update_super_partner_member_setup', as: 'update_super_partner_member_setup'
      delete 'super_partner_member_setup_delete', to: "super_partners#destroy_super_partner_member"
      resources :super_partner_steps
    end

    namespace :partner_manage do
      get 'index', to: 'partners#index'
      get 'partner_details/:id', to: 'partners#partner_details', as: 'partner_details'
      get 'partner_details/edit/:id', to: 'partners#edit_partner_details', as: 'edit_partner_details'
      post 'partner_details/update/:id', to: 'partners#update_partner_details', as: 'update_partner_details'
      get 'partner_details/:id/member_setup/new',to: 'partners#new_partner_member_setup', as: 'new_partner_member_setup'
      post 'partner_details/:id/member_setup/create',to: 'partners#create_partner_member_setup', as: 'create_partner_member_setup'
      get 'partner_details/:partner_id/member_setup/edit/:id', to: 'partners#edit_partner_member_setup', as: 'edit_partner_member_setup'
      get 'partner_details/:partner_id/member_setup/show/:id', to: 'partners#show_partner_member_setup', as: 'show_partner_member_setup'
      post 'partner_details/:partner_id/member_setup/update/:id', to: 'partners#update_partner_member_setup', as: 'update_partner_member_setup'
      get 'partner_details/:id/partner_member_list', to: 'partners#partner_member_list', as: 'partner_member_list'
      delete 'partner_member_setup_delete', to: "partners#destroy_partner_member"
      resources :partner_steps
    end

    namespace :student_manage do
      get 'search_student', to: 'student#search_student'
      get 'search_student_details/:id', to: 'student#student_details', as: 'search_student_details'
      get 'overview/:id', to: 'student#overview', as: 'student_overview'
      get 'commitment/edit/:id', to: 'student#edit_commitment', as: 'edit_student_commitment'
      post 'commitment/update/:id', to: 'student#update_commitment', as: 'update_student_commitment'
      get 'student_detail/edit/:id', to: 'student#edit_student_detail', as: 'edit_student_detail'
      post 'student_detail/update/:id', to: 'student#update_student_detail', as: 'update_student_detail'
      get 'student/assessment/:id', to: 'student#assessment', as: 'assessment'
      get 'student/apply_vacancy_list/:id', to: 'student#apply_vacancy_list', as: 'apply_vacancy_list'
      get 'student/favourite_vacancy_list/:id', to: 'student#favourite_vacancy_list', as: 'favourite_vacancy_list'
      get 'student/favourite_company_list/:id', to: 'student#favourite_company_list', as: 'favourite_company_list'
      get 'student/favourite_event_list/:id', to: 'student#favourite_event_list', as: 'favourite_event_list'
      get 'student/join_event_list/:id', to: 'student#join_event_list', as: 'join_event_list'
    end

    namespace :company_manage do
      get 'company_search', to: 'company#company_search'
      get 'company_details_overview', to: 'company#company_details_overview'
      get 'company_details_basic_info', to: 'company#company_details_basic_info'
      get 'company_details_company_page', to: 'company#company_details_company_page'
      get 'company_details_activity_page', to: 'company#company_details_activity_page'
      get 'company_commitment/edit/:company_id', to: 'company#edit_commitment', as: 'edit_commitment'
      post 'company_commitment/update/:company_id', to: 'company#update_commitment', as: 'update_commitment'
      get 'company/edit/:company_id', to: 'company#edit_company', as: 'edit'
      post 'company/update/:company_id', to: 'company#update_company', as: 'update'
      get 'company/favourite_student_list', to: 'company#favourite_student_list', as: 'favourite_student_list'   
      get 'company/join_event_list', to: 'company#join_event_list', as: 'join_event_list'   
      get 'company/company_event_list', to: 'company#company_event_list', as: 'company_event_list'  
      get 'company/company_vacancy_list', to: 'company#company_vacancy_list', as: 'company_vacancy_list' 
    end

    namespace :event_manage do
      get 'search_event', to: 'event#search_event'
      get 'search_event_detail/:id', to: 'event#search_event_detail' , as: 'search_event_detail'
      get 'event_apply_student_list/:id', to: 'event#event_apply_student_list' , as: 'event_apply_student_list'
    end 

    namespace :vacancy_manage do
      get 'search_vacancy', to: "vacancy#search_vacancy"
      get 'search_vacancy_detail/:id', to: 'vacancy#search_vacancy_detail', as: 'search_vacancy_detail'
      get 'vacancy_applied_student_list/:id', to: 'vacancy#vacancy_applied_student_list', as: 'vacancy_applied_student_list' 
    end
    
    get 'kodawari_setting', to: 'setting#kodawari_setting'
    post 'password_update', to: 'setting#password_update'
  end

  # api
  defaults format: :json do
    namespace :api do
      namespace :v1 do
        resources :events, only: [:index]
      end
    end
  end

  # Company Page
  get ':id/home', to: 'company_page#home', as: 'company_page_home'
  get ':id/about_us', to: 'company_page#about_us', as: 'company_page_about_us'
  get ':id/members', to: 'company_page#members', as: 'company_page_members'
  get ':id/stories', to: 'company_page#stories', as: 'company_page_stories'
  get ':id/activity', to: 'company_page#activity', as: 'company_page_activity'
  get ':id/recruitment', to: 'company_page#recruitment', as: 'company_page_recruitment'
  get ':id/vacancies', to: 'company_page#vacancies', as: 'company_page_vacancies'
  get ':id/events', to: 'company_page#events', as: 'company_page_events'
  get ':id/story_detail/:story_id', to: 'company_page#story_detail', as: 'story_details'
  get ':id/vacancy_detail/:vacancy_id', to: 'company_page#vacancy_detail', as: 'vacancy_details'
  get ':id/event_detail/:event_id', to: 'company_page#event_detail', as: 'event_details'
  get ':id/activity_detail/:activity_id', to: 'company_page#activity_detail', as: 'activity_details'


  #begin::event_wait
  namespace :event_wait do
    get 'create_event_wait/:event_id/:join_user_type/:join_parent_user_id/:join_user_id', to: 'event_wait#create_event_wait'
  end
  #end::event_wait
  root to: 'welcome/welcomes#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
