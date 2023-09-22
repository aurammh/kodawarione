class KodawariConfig < ApplicationRecord
    def self.progress_details
        [ 
            {"name"=>"student_temporary_registration_form", "value"=>"1"},
            {"name"=>"student_commitment_ability_form", "value"=>"2"},
            {"name"=>"student_main_registration_screen", "value"=>"3"},      
            {"name"=>"assessment_1_form", "value"=>"4"}, 
            {"name"=>"assessment_2_form", "value"=>"5"}, 
            {"name"=>"assessment_3_form", "value"=>"6"}, 
            {"name"=>"student_questionnaire_answer_form", "value"=>"7"},
        ]    
    end

    def self.company_progress_details
        [ 
            {"name"=>"company_temporary_registration_form", "value"=>"1"},
            {"name"=>"company_commitment_ability_form", "value"=>"2"},
            {"name"=>"company_basic_information_form", "value"=>"3"},                 
            {"name"=>"company_questionnaire_answer_form", "value"=>"4"}, 
            {"name"=>"company_home_page", "value"=>"5"},
            {"name"=>"company_about_us_page", "value"=>"6"}, 
            {"name"=>"company_member_page", "value"=>"7"}, 
            {"name"=>"company_recruitment_page", "value"=>"8"}, 
        ]    
    end

    def self.student_kodawari_profile_params
        [
            "cover_color","nick_name","current_address","preferred_working_area","commitment","birthday", "gender","qualification_string"
        ]
    end

    def self.student_kodawari_assessment_params
        [
            "ability","ability_one","ability_two","ability_three","ability_reason_one","ability_reason_two","ability_reason_three"
        ]
    end

    def self.student_profile_params
        [
            "image", "last_name", "first_name", "last_name_kana", "first_name_kana",
            "email_two", "phone_no", "postal_code", "postalcode_city", "address", 
            "display_address", "school_type", "school_name", "department_name", "subject_system", "qualification_category_id", "qualification_type_id",
            "graduation_date", "desire_industry_type_id", "desire_job_type_id", "m_region_id", "m_prefecture_id", "job_info",
            "club_name", "club_position", "club_detail_activity", "outside_school_activity", "club_guide", "sns_blog_for_pr"
        ]
    end

    def self.student_assessment1_params
        [
            "logical_and_rational", "solid_and_planned", "sensory_and_friendly", "adventurous_and_original",
        ]
    end
    def self.student_assessment2_params
        [            
            "love_and_desire_to_belong", "desire_for_power_and_value", "desire_for_freedom", "desire_for_fun", "desire_for_survival",
        ]
    end

    def self.student_assessment3_params
        [           
            "self_expression", "self_assertion", "self_flexibility"
        ]
    end

    def self.company_kodawari_profile_params
        [
            "company_name", "company_name_kana", "phone_no", "postal_code", "m_region_id", "m_prefecture_id", "postalcode_city", "address", "display_address", "company_established", "website_url"
        ]
    end

    def self.company_kodawari_assessment_params
        [
            "ability", "ability_one", "ability_reason_one", "ability_two", "ability_reason_two", "ability_three", "ability_reason_three"
        ]
    end
    
    def self.company_profile_params
        [ 
            "capital_amount", "sales_amount", "related_company", "main_bank", "basic_idea", "representative", "contact", "transportation_facilities"
        ]
    end

    def self.company_commitment_profile_params
        [ 
            "cover_photo", "image", "m_industry_id", "job_info", "employee_count", "company_intro", "history"
        ]
    end

    def self.company_about_us_params
        [ 
            "company_message", "other_message", "company_vision_mission", "what_we_do", "how_we_do"
        ]
    end

    def self.company_member_params
        [ 
            "about_our_team", "member_message"
        ]
    end

    def self.company_recruitment_params
        [ 
            "experience_requirements", "fresher_requirements", "fresher_second_requirements"
        ]
    end
end