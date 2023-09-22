module CommonHelper
    require 'bcrypt'
    def except_action
        ["admin_events/join_admin_events","admin_events/new","search/favourite_student","search/index","search/search_event","search/favourite_student","search/student_search","companies/index", "sessions/destroy", "welcomes/index" ,"companies/company_genuine_password_change" ,"companies/company_genuine_password","commitment_profiles/show","commitment_profiles/edit" ,"companies/company_setting","companies/company_setting_update","communications/conversation_forum","communications/index","communications/show","communications/edit","communications/update","communications/create","communications/destroy","communication_details/index","communication_details/show","communication_details/new","communication_details/create","communication_details/edit","communication_details/update","communication_details/destroy"]
    end
    def check_permission?(user_id,permission_type)
        return (@permission_type.select { |v| v.permission_type == "#{permission_type}" && v.user_id == user_id }.empty?) ? true : false
    end

    def permission_check_box(type_id,user_id)
        @permissions.each do |data|
         if data.admin_permission_type_id == type_id &&  data.user_id == user_id
            return true
         end
        end
        return false
    end
    
    #get data for select box
    def industry_type_options
        MIndustry.all
    end
    
    def region_options
        MRegion.select(:id,:region_name).order(id: :asc)
    end

    def commitment_options
        MCommitmentAbility.select(:id,:name).order(id: :asc)
    end
    
    def prefecture_options
        MPrefecture.all
    end

    def prefecture_options_for_residence
        MPrefecture.where("m_region_id > 1")
    end

    def prefecture_options_for_vacancy_search
        MPrefecture.where("m_region_id between ? and ?", 2, 9)
    end

    def qualification_options
        MQualification.select(:id,:qualification_category).order(id: :asc)
    end

    def qualification_details_options
        MQualificationDetail.select(:id,:qualification_type).order(id: :asc)
    end

    def occupation_options
        MOccupation.select(:id,:occupation_name).order(id: :asc)
    end

    def welfare_options
        MWelfare.select(:id,:welfare_category).order(id: :asc)
    end

    def welfare_detail_options
        MWelfareDetail.select(:id,:welfare_type).order(id: :asc)
    end

    #get prefecture according region
    def prefecture_name_list
        region_id = params[:id]
        prefecture_name_list = MPrefecture.select(:id, :prefecture_name).where(m_region_id: region_id).order("id asc")
        render json: prefecture_name_list
    end

    #get value from json object
    def getJsonKey (hashArray)
        keyVal = [] 
        unless hashArray.nil?  
        hashArray.each {|k, v| keyVal << v }
        end
        keyVal
    end
    
    # get qualification category name
    def get_qualification_category(qualification_category)
        if qualification_category.any?
            qualification_category_name = qualification_category.select { |item| nil != item }
            MQualification.where("id IN (#{qualification_category_name.join(',')})").map { |qc| [qc.qualification_category]}.join(', ')
        end
    end

    # get qualification detail
    def get_qualificaion_type(qualification_type)
        if qualification_type.any?
            qualification_type_name = qualification_type.select { |item| nil != item }
            MQualificationDetail.where("id IN (#{qualification_type_name.join(',')})").map { |qt| [qt.qualification_type]}.join(', ')
        end
    end

    # get selected MPrefecture name by id
    def get_MPrefecture_by_id(postal_prefecture_id)
        if postal_prefecture_id.present?
            MPrefecture.find_by_id(postal_prefecture_id).present? ? MPrefecture.find_by_id(postal_prefecture_id).prefecture_name: ''
        end
    end

    # get selected industry name
    def get_industry_name(industry_id)
        if industry_id.any?
            industryType = industry_id.select { |item| nil != item }
            MIndustry.where("id IN (#{industryType.join(',')})").map { |ind| [ind.industry_name]}.join(', ')
        end
    end

    # get selected occupation name
    def get_occupation_name(job_id)
        if job_id.any?
            jobType = job_id.select { |item| nil != item }
            MOccupation.where("id IN (#{jobType.join(',')})").map { |jt| [jt.occupation_name]}.join(', ')
        end
    end

    # get selected location name
    def get_region_name(region_id)
        if region_id.present?
            MRegion.find(region_id).present? ? MRegion.find(region_id).region_name : ''
        end
    end

    # get selected prefecture name
    def get_prefecture_name(prefecture_id)
        if prefecture_id.present?
            MPrefecture.find_by_id(prefecture_id).present? ? MPrefecture.find_by_id(prefecture_id).prefecture_name : ''
        end
        # if prefecture_id.any?
        #     prefecture_name = prefecture_id.select { |item| nil != item }
        #     MPrefecture.where("id IN (#{prefecture_name.join(',')})").map { |p| [p.prefecture_name]}.join(', ')
        # end
    end

    # get selected prefecture name with multi select
    def get_prefecture_name_with_multi_select(prefecture_id)
        if prefecture_id.any?
            prefecture_name = prefecture_id.select { |item| nil != item }
            MPrefecture.where("id IN (#{prefecture_name.join(',')})").map { |p| [p.prefecture_name]}.join(', ')
        end
    end

    # get selected industry name by ID
    def get_industry_name_by_ID(industry_id)
        if industry_id.present?
            MIndustry.find(industry_id).industry_name
        end
    end

    # create data with hash
    def get_hash_value(obj)
        @count = Hash.new
        obj.each do |e|
            @count[e.id] = e.join_count
        end
    end

    # convert image base64 type to blob
    def convert_Base64_imgData(b64_params)
        filename = b64_params.split(",")[0];
        blob = ActiveStorage::Blob.create_after_upload!(
        io: StringIO.new((Base64.decode64(b64_params.split(",")[2]))),
        filename: filename,
        content_type: "image/jpeg",
        )
    end

    # get unread conversation
    def new_communication_array
        @new_communication_arr = []
        user_id = current_company_user.present? ? current_company_user.id : current_user.id
        new_communication = Communication::Notification.where(receiver_id: user_id)
        @new_communication_arr = new_communication.map{|data| data.record_id} unless @new_communication.present?
    end

      # get unread conversation
    def partner_new_communication_array(user_id)
        @new_communication_arr = []
        #user_id = current_company_user.present? ? current_company_user.id : current_user.id
        new_communication = Communication::Notification.where(receiver_id: user_id)
        @new_communication_arr = new_communication.map{|data| data.record_id} unless @new_communication.present?
    end

    #get date and time for communication tools
    def time_date(date)
        if date.year > Time.now.year
            date.strftime('%Y年%m月%d日')
        else 
            date.to_date == Time.now.to_date ? date.strftime('%l:%M %p') : t('date.abbr_month_names')[date.month] + date.day.to_s + t('date.prompts.day')
        end
    end

    def kodawari_options
        MCommitmentAbility.all
    end

    def company_role_type_options
        Company::Role.where(company_id: nil).or(Company::Role.where(company_id: current_company.id)).map{ |company_role| [t("company_user_roles.#{company_role.role_type}"), company_role.id] }
    end

    def get_student_info
        @results = Student::Student.select('students.*')
    end

    def get_company_info
        @results =Company::Company.all
    end

    def get_sender_info(company_user_id,user_id,company_id ,mail_type,sent_type)
        # sender ( me or name) : receiver (me or name)
        receiver = Hash.new
        ## Company [name] <=> Student [name]
        if mail_type == 1             
            # check sent_type
            # sender is company name   
            if sent_type == LogoutHistory.active_types["company"].to_i 
                receiver["name"] = Company::Company.find(company_id).company_name
                receiver["email"] = CompanyUser.find(company_user_id).email
            else
                # receiver is company name   
                student_info = get_student_info.find_by(:user_id => sender_id)
                receiver["name"] = student_info.nick_name
                receiver["email"] = User.find(user_id).email
            end
        else
            ## Company_User [name] <=> Student [name]
            if sent_type == LogoutHistory.active_types["company"].to_i 
                com_info = CompanyUser.find_by(:id => company_user_id)
                receiver["name"] = com_info["last_name"]+" "+com_info["first_name"] 
                receiver["email"] = com_info.email
            else
                student_info = get_student_info.find_by(:user_id => user_id)
                receiver["name"] = student_info["nick_name"]  
                receiver["email"] = User.find(user_id).email
            end
        end
        return receiver
    end
    
    def get_receiver_info(company_user_id,user_id,company_id,mail_type,sent_type)
        receiver = Hash.new       
        ## Company [name] <=> Student [name]
        if mail_type == 1             
            # check sent_type
            if sent_type == LogoutHistory.active_types["company"].to_i 
                student_info = get_student_info.find_by(:user_id => user_id)
                receiver["name"] = student_info.nick_name
                receiver["email"] = User.find(user_id).email
            else
                receiver["name"] = Company::Company.find(company_id).company_name
                receiver["email"] = CompanyUser.find(company_user_id).email
            end
        else
            ## Company_User [name] <=> Student [name]
            if sent_type == LogoutHistory.active_types["company"].to_i 
                # sender is studnet name   
                student_info = get_student_info.find_by(:user_id => user_id)
                receiver["name"] = student_info.nick_name
                receiver["email"] = User.find(user_id).email
            else
                # receiver is company_user first_name + last_name  
                com_user_info = CompanyUser.find_by(:id => company_user_id)
                com_info = Company::Company.find_by(:id => company_user_id)
                receiver["name"] = com_user_info.last_name.present? ? com_user_info["last_name"]+" "+com_user_info["first_name"] : com_info.company_name
                receiver["email"] = com_user_info.email
            end
        end
        return receiver
    end
    
    def get_sender_detail_info(company_user_id,user_id,company_id ,mail_type,sent_type)
        # sender ( me or name) : receiver (me or name)
        receiver = Hash.new
        ## Company [name] <=> Student [name]
        if mail_type == 1             
            # check sent_type
            # sender is company name   
            if sent_type == LogoutHistory.active_types["company"].to_i 
                receiver["name"] = Company::Company.find(company_id).company_name
                receiver["email"] = CompanyUser.find(company_user_id).email
            else
                # receiver is company name   
                student_info = get_student_info.find_by(:user_id => user_id)
                receiver["name"] = student_info.nick_name
                receiver["email"] = User.find(user_id).email
            end
        else
            ## Company_User [name] <=> Student [name]
            if sent_type == LogoutHistory.active_types["company"].to_i 
                #sender is company_user first_name + last_name  
                com_user_info = CompanyUser.find_by(:id => company_user_id)
                com_info = Company::Company.find_by(:id => company_user_id)
                receiver["name"] = com_user_info.last_name.present? ? com_user_info["last_name"]+" "+com_user_info["first_name"] : com_info.company_name
                receiver["email"] = com_user_info.email
            else
                #sender is studnet name   
                student_info = get_student_info.find_by(:user_id => user_id)
                receiver["name"] = student_info["nick_name"] 
                receiver["email"] = User.find(user_id).email
            end
        end
        return receiver
    end
    
    def get_sender_communication_info(company_user_id,user_id,company_id ,mail_type,sent_type)  
        # sender ( me or name) : receiver (me or name)
        receiver = Hash.new
        if sent_type === 1 # [Company => student]
            if mail_type === 1 # [Scouted message , Company <=> Student ]
                receiver["name"] =  Company::Company.find(company_id).company_name
            else # [Direct message , Company_Members <=> Student ]
                if check_login_person_info(company_user_id,1)
                    receiver["name"] = "me" 
                else
                    com_user_info = CompanyUser.find_by(:id => company_user_id)
                    com_info = Company::Company.find_by(:id => company_user_id)
                    receiver["name"] = com_user_info.last_name.present? ? com_user_info["last_name"]+" "+com_user_info["first_name"] : com_info.company_name
                    receiver["email"] = com_user_info.email
                end
            end
            receiver["email"] = CompanyUser.find(company_user_id).email
        else # sent_type => 2 [ student  => Company]
            if check_login_person_info(user_id,2)
                receiver["name"] = "me" 
            else
                student_info = get_student_info.find_by(:user_id => user_id)
                receiver["name"] = student_info.nick_name
            end
            receiver["email"] = User.find(user_id).email
        end
        return receiver
    end

    def get_sender_communication(company_user_id,user_id,company_id ,mail_type,sent_type)  
        # sender ( me or name) : receiver (me or name)
        receiver = Hash.new
        if sent_type === 1 # [Company => student]
            if mail_type === 1 # [Scouted message , Company <=> Student ]
                receiver["name"] =  Company::Company.find(company_id).company_name
            else # [Direct message , Company_Members <=> Student ]
                com_user_info = CompanyUser.find_by(:id => company_user_id)
                com_info = Company::Company.find_by(:id => company_user_id)
                receiver["name"] = com_user_info.last_name.present? ? com_user_info["last_name"]+" "+com_user_info["first_name"] : com_info.company_name
                receiver["email"] = com_user_info.email
            end
            receiver["email"] = CompanyUser.find(company_user_id).email
        else # sent_type => 2 [ student  => Company]
            student_info = Student::Student.find_by(:user_id => user_id)
            
            receiver["name"] = student_info.nick_name
            
            receiver["email"] = User.find(user_id).email
        end
        return receiver
    end

    def get_receiver_communication(company_user_id,user_id,company_id,mail_type,sent_type)
        # sender ( me or name) : receiver (me or name)
        receiver = Hash.new
        if sent_type === 2 # [Student => Company receiver]
            if mail_type === 1 # [Scouted message , Company <=> Student ]
                receiver["name"] =  Company::Company.find(company_id).company_name
            else # [Direct message , Company_Members <=> Student ]
                com_user_info = CompanyUser.find_by(:id => company_user_id)
                com_info = Company::Company.find_by(:id => company_user_id)
                receiver["name"] = com_user_info.last_name.present? ? com_user_info["last_name"]+" "+com_user_info["first_name"] : com_info.company_name
                receiver["email"] = com_user_info.email
              
            end
            receiver["email"] = CompanyUser.find(company_user_id).email
        else # sent_type => 1 [ Company  => student receiver ]
           
            student_info = Student::Student.find_by(:user_id => user_id)
            receiver["name"] = student_info.nick_name
            receiver["email"] = User.find(user_id).email
        end
        return receiver
    end
    
    def get_receiver_communication_info(company_user_id,user_id,company_id,mail_type,sent_type)
        # sender ( me or name) : receiver (me or name)
        receiver = Hash.new
        if sent_type === 2 # [Student => Company receiver]
            if mail_type === 1 # [Scouted message , Company <=> Student ]
                receiver["name"] =  Company::Company.find(company_id).company_name
            else # [Direct message , Company_Members <=> Student ]
                if check_login_person_info(company_user_id,1)
                    receiver["name"] = "me" 
                else
                    com_user_info = CompanyUser.find_by(:id => company_user_id)
                    com_info = Company::Company.find_by(:id => company_user_id)
                    receiver["name"] = com_user_info.last_name.present? ? com_user_info["last_name"]+" "+com_user_info["first_name"] : com_info.company_name
                    receiver["email"] = com_user_info.email
                end
            end
            receiver["email"] = CompanyUser.find(company_user_id).email
        else # sent_type => 1 [ Company  => student receiver ]
            if check_login_person_info(user_id,2)
                receiver["name"] = "me" 
            else
                student_info = get_student_info.find_by(:user_id => user_id)
                receiver["name"] = student_info.nick_name 
            end
            receiver["email"] = User.find(user_id).email
        end
        return receiver
    end

    def check_login_person_info(user_id,user_type)
        login_id = current_user_data.id 
        if login_id === user_id && check_user_type === user_type
            return true
        end
        return false
    end

    def select_direct_msg_for_company(conversation_lists)
        array_obj_list = Array.new
        conversation_lists.each do |list|
            if list.mail_type === 2 # Direct message type
                if (list.sent_type === 1 && list.sender_id === current_company_user.id) || (list.sent_type === 2 && list.receiver_id === current_company_user.id)
               array_obj_list << list
                end
            end 
        end 
        return array_obj_list
    end

    def get_comminication_list_count(communication_id)
        Communication::CommunicationDetail.where(communication_id: communication_id).count
    end

    def partner_user_options
        PartnerUser.select(:id,"CONCAT(last_name,' ',first_name) as name").where(partner_id: current_partner_user.id).order(id: :asc)
    end

    def get_student_field_name(value) 
        value.present?? value : "-" 
    end

    def get_graduation_date(value) 
        # value.present?? "#{value.split('-')[0]}#{t'date.prompts.year'}#{value.split('-')[1]}#{t'date.prompts.month'}" : "-"
        
        if value.present? && (value.include? "-" )
             "#{value.split('-')[0]}#{t'date.prompts.year'}#{value.split('-')[1]}#{t'date.prompts.month'}"
        elsif value.present? && !(value.include? "-" )
            value 
        else
            "-"
        end
    end
    
    def get_gender(value) 
        value.present?? t("student.gender.#{value}") : "-" 
    end

    def get_birthday(value) 
        value.present?? "#{Date.today.year-value.year} #{t("unit.age")}"  : "-"  
    end

    def get_school_type(value) 
        value.present?? t("student.school_type.#{value}") : "-" 
    end

    def get_applicant(value)
        value.present?? t("applicant.#{value}")  : '-'
    end
    # insert into application_status_transaction & application_status_transaction_detail
    def create_application_status(std_id,com_id,communication_id,vacancy_id,type_id,updated_user_role)
        #begin::save application_status_transaction table
        @application_status_transaction = ApplicationStatusTransaction.new
        @application_status_transaction.student_id = std_id
        @application_status_transaction.company_id = com_id
        @application_status_transaction.communication_id = communication_id if updated_user_role == 1
        @application_status_transaction.company_vacancy_id = vacancy_id
        @application_status_transaction.status = 2
        @application_status_transaction.save
        #end::save application_status_transaction table

        #begin::save application_status_transaction_detail table
        @application_status_transaction_detail = ApplicationStatusTransactionDetail.new
        @application_status_transaction_detail.application_status_transaction_id = @application_status_transaction.id
        # [ 1 -> apply, 2 -> scouted ]
        @application_status_transaction_detail.type_id = type_id
        # [ 2 -> waiting for interview arrangement ]
        @application_status_transaction_detail.status = 2
        # [ 1 -> student, 2 -> company, 3 -> partner, 4 -> admin ]
        @application_status_transaction_detail.updated_user_role = updated_user_role
        @application_status_transaction_detail.updated_user_id = std_id if updated_user_role == 1 
        @application_status_transaction_detail.updated_user_id = com_id if updated_user_role == 2
        @application_status_transaction_detail.save
        #end::save application_status_transaction_detail table
    end

    def scout_mail_sender_and_receiver_info(company_user_id,user_id,company_id,mail_type,sent_type)
        receiver = Hash.new
        if check_login_person_info(user_id,2)
            mail_info = get_company_info.find_by(:id => company_id)
            receiver["name"] = mail_info.company_name 
        else
            mail_info = get_student_info.find_by(:user_id => user_id)
            receiver["name"] = mail_info.nick_name 
        end
        receiver["email"] = User.find(user_id).email
        return receiver,mail_info
    end

    def page_render_on_scout_submit
        if cookies[:previous_url] == "/student/scouted_result"
            redirect_to student_scouted_result_path
        elsif cookies[:previous_url] == "/student/students"
            redirect_to student_students_path
        elsif cookies[:previous_url] == "communication/communications?mail_type=1111"
            redirect_to communication_communications_path(mail_type: "1111")
        end
    end

    def copy_registration_link  
        partner_partner = Partner::Partner.find(current_partner_user.partner_id)
        encrypted_partner_code = BCrypt::Password.create(partner_partner.partner_code, :cost => 6).to_s
        @student_url = request.base_url + new_user_registration_path(partner_code: encrypted_partner_code)
        @company_url = request.base_url + new_company_company_path(partner_code: encrypted_partner_code)
        return @student_url,@company_url
    end

    def copy_admin_registration_link 
        partner_partner = Partner::Partner.find(current_admin.admin_member.admin_roles_id)
        encrypted_partner_code = BCrypt::Password.create(partner_partner.partner_code, :cost => 6).to_s
        @student_url = request.base_url + new_user_registration_path(partner_code: encrypted_partner_code)
        @company_url = request.base_url + new_company_company_path(partner_code: encrypted_partner_code)
        return @student_url,@company_url
    end
    
    def get_event_participant_count(event_id)
        Admin::EventParticipant.where('admin_event_id = ? ', event_id).count
    end

    ################################
    # Role permission setting
    ################################
    def current_auth_resource
        if admin_signed_in?
          current_admin
        elsif company_user_signed_in?
          current_company_user
        end
    end
    
    def current_ability
        @current_ability or @current_ability = Ability.new(current_auth_resource)
    end

    def get_super_partner_member(super_partner_id)
        @super_partner_users = Kodawarione::AdminMember.where(super_partners_id: super_partner_id, admin_roles_id: 2, delete_flg: false).length
    end

    def get_partner_member(partner_id)
        @partner_users = Kodawarione::AdminMember.where(partners_id: partner_id, delete_flg: false).length
    end

    def super_partner_options_for_partner_create
        Kodawarione::SuperPartner.all
    end

    # Get admin role type
    def get_admin_role_type
        if current_admin.chief_administrator?
            t'company_user_roles.chief_administrator1'
        elsif current_admin.super_partner?
            t'partner.super_partners_tab1'
        elsif current_admin.partner?
            t'partner.partners_tab1'
        end
    end

    # Admin Role type [ chief_administrator - 1, super_partner - 2, partner - 3 ]
    def set_admin_role_type
        if current_admin
            if current_admin.chief_administrator?
                1
            elsif current_admin.super_partner?
                2
            elsif current_admin.partner?
                3
            end
        end
    end

    # Query With Role 
    def query_with_current_role(table_name, query_type)
        if current_admin
          if current_admin.chief_administrator?
            case query_type
                when "news_search"
                    return "#{table_name}.created_by_id = ? and #{table_name}.news_type = #{set_admin_role_type}",current_admin.id
                when "plans_index"
                    return "#{table_name}.created_id = ? and #{table_name}.plan_role_type = #{set_admin_role_type}",current_admin.id
                when "contracts_index"
                    return "#{table_name}.contract_from_id = ? and #{table_name}.contract_role_type = #{set_admin_role_type}",current_admin.id
                when "event_list" 
                    return "#{table_name}.created_by_id = ? and #{table_name}.event_type = 3",current_admin.id
                else
                    return
            end
          elsif current_admin.super_partner?
            case query_type
                when "partner_search"
                    return "#{table_name}.id in (?)",get_query_partner_list_with_super_partner_id
                when "student_search"
                    return "#{table_name}.partner_id in (?)",get_query_partner_list_with_super_partner_id
                when "company_search"
                    return "#{table_name}.partner_id in (?)",get_query_partner_list_with_super_partner_id
                when "news_search"
                    return "#{table_name}.created_by_id = ? and #{table_name}.news_type = #{set_admin_role_type}",current_admin.id
                when "plans_index"
                    return "#{table_name}.created_id = ? and #{table_name}.plan_role_type = #{set_admin_role_type}",current_admin.id
                when "contracts_index"
                    return "#{table_name}.contract_from_id = ? and #{table_name}.contract_role_type = #{set_admin_role_type}",current_admin.id
                when "event_search"
                    return "#{table_name}.created_by_id in (?) and #{table_name}.event_show_option IN (3,5) ", get_company_id_by_super_partner
                when "vacancy_search"
                    return "#{table_name}.partner_id in (?)",get_query_partner_list_with_super_partner_id
                when "event_list" 
                    return "#{table_name}.created_by_id = ? and #{table_name}.event_type = 3",current_admin.id 
                else
                    return
            end
          elsif current_admin.partner?
            case query_type
                when "student_search"
                    return "#{table_name}.partner_id = ?", current_admin.admin_member.partners_id
                when "company_search"
                    return "#{table_name}.partner_id = ?", current_admin.admin_member.partners_id
                when "news_search"
                    return "#{table_name}.created_by_id = ? and #{table_name}.news_type = #{set_admin_role_type}",current_admin.id
                when "plans_index"
                    return "#{table_name}.created_id = ? and #{table_name}.plan_role_type = #{set_admin_role_type}",current_admin.id
                when "contracts_index"
                    return "#{table_name}.contract_from_id = ? and #{table_name}.contract_role_type = #{set_admin_role_type}",current_admin.id
                when "event_search"
                    return "#{table_name}.created_by_id in (?) and #{table_name}.event_show_option IN (3,4) ", get_company_id_by_partner  
                when "vacancy_search"
                    return "#{table_name}.partner_id in (?)", current_admin.admin_member.partners_id           
                when "event_list" 
                    return "#{table_name}.created_by_id = ? and #{table_name}.event_type = 3",current_admin.id
                else
                    return
            end
          end
        end
    end

    # Query With Role For Patner Role
    def get_query_partner_list_with_super_partner_id
        Kodawarione::Partner.select(:id).where(super_partner_id: current_admin.admin_member.super_partners_id).map(&:id)
    end

    def get_query_partner_with_partner_id
        Kodawarione::Partner.find_by(id: current_admin.admin_member.partners_id)
    end 

    def get_company_id_by_partner
        Company::Company.select(:id).where(partner_id: current_admin.admin_member.partners_id)
    end

    def get_company_id_by_super_partner
        Company::Company.select(:id)
        .joins("INNER JOIN partners ON partners.id = companies.partner_id")
        .where("partners.super_partner_id = #{current_admin.admin_member.super_partners_id}")
    end

    def kodawari_sidebar_info
        if current_admin.chief_administrator?
            t('kodawarione.sidebar.headquarters_manager')
        elsif current_admin.super_partner?
            Kodawarione::SuperPartner.find(current_admin.admin_member.super_partners_id).name
        elsif current_admin.partner?
            Kodawarione::Partner.find(current_admin.admin_member.partners_id).name
        end 
    end
    

end
