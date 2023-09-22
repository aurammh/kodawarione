module Company::CompaniesHelper
    def mail_setting_options
        Company::Company.mail_settings.map{|k,v| [t("mail_setting.#{k}"),v]}
    end
    
    def vacancy_options(student_id)
        Company::Company.new.get_scout_vacancy_list(current_company.id, student_id)
    end

    # A method which will return true or false if vacancy has expired or not
    def expiry_day_left(from_date, to_date)
        unless is_expired?(from_date, to_date)
            days_left = (to_date - Date.today).to_i
            return "#{t("detail.text.days_left")} #{days_left} #{t("date.prompts.day")}" 
        else
            return t("detail.text.expired")
        end
    end
    
    # A method which will return true or false if vacancy has expired or not
    def is_expired?(from_date, to_date)
        (to_date - Date.today).to_i <= 0  ? true : false
    end
    
    def get_vacancy_title(vacancy_id)
        Company::Vacancy.find(vacancy_id).vacancy_title
    end
    
end