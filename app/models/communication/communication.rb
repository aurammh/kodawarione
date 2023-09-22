class Communication::Communication < ApplicationRecord
    has_many :communication_detail ,class_name: "Communication::CommunicationDetail",foreign_key: "communication_id", dependent: :destroy
    has_rich_text :content
    has_one :action_text_rich_text,class_name: 'ActionText::RichText',as: :record
    self.table_name = "communications"

    attr_accessor :save_template_chk_box, :mail_template_id
    
    enum category: {
        company: "Company",
        student: "Student",
        event: "Event",
        vacancy: "Vacancy",
        member: "Member"
    }, _prefix: true

    #enum for scout status
    enum scout_status: { waiting_accept: 1, accept: 2, denied: 3 } 

    #return [enum value]
    def self.scout_status_attributes_for_select 
        scout_statuses.map{ |k,v| [I18n.t("activerecord.attributes.#{model_name.i18n_key}.scout_statuses.#{k}"),v] }
    end

    def get_all_communication(user_id,company_user_id,company_id, mail_type,check_user_type)
        where_caluse = ""
        if check_user_type === LogoutHistory.active_types["user"].to_i
            if mail_type === 1
                where_caluse= "communications.user_id = #{user_id} AND communications.mail_type = 1"
            else
                where_caluse= "communications.user_id = #{user_id} AND communications.mail_type = 2"
            end
        else 
            if mail_type === 1
                where_caluse= "communications.company_id = #{company_id} AND communications.mail_type = 1"
            else
                where_caluse= "communications.company_id = #{company_id} AND communications.mail_type = 2 AND communications.company_user_id = #{company_user_id} "
            end
        end
        
        Communication::CommunicationDetail.select('distinct on(communication_details.communication_id) communication_id,communication_details.id,communication_details.created_at,communications.sent_type,communications.user_id,communications.company_user_id,
        communications.sender_id,communications.receiver_id,
        communications.title,communications.scout_status,communications.category,communications.company_id, communications.mail_type')
        .joins(:communication)
        .where(where_caluse)
        .order('communication_details.communication_id  desc, communication_details.created_at desc')
    end

    def get_student(mail_type, partner_id)
        Communication::Communication.select('distinct (students.id) ')
        .joins("left join students on students.id = communications.user_id ")
        .joins("left join users on users.id = students.user_id")
        .where("communications.mail_type= #{mail_type} and students.delete_flg = 'false' and users.partner_id = #{partner_id}")
    end

    def get_company(mail_type,partner_id)
        Communication::Communication.select('distinct (companies.id) ')
        .joins("left join companies on companies.id = communications.company_id left join partners on partners.id = companies.partner_id ")
        .where("companies.delete_flg = 'false' and communications.mail_type = #{mail_type} and partners.id = #{partner_id}")
    end

    def get_spu_company(mail_type,spu_id_list)
        Communication::Communication.select('distinct (companies.id) ')
        .joins("left join companies on companies.id = communications.company_id left join partners on partners.id = companies.partner_id ")
        .where("companies.delete_flg = 'false' and communications.mail_type = #{mail_type} and partners.id in (#{spu_id_list})")
    end

    def get_spu_student(mail_type,spu_id_list)
        Communication::Communication.select('distinct (students.id) ')
        .joins("left join students on students.id = communications.user_id ")
        .joins("left join users on users.id = students.user_id")
        .where("communications.mail_type= #{mail_type} and students.delete_flg = 'false' and users.partner_id in (#{spu_id_list})")
    end

    def get_admin_company(mail_type)
        Communication::Communication.select('distinct (companies.id) ')
        .joins("left join companies on companies.id = communications.company_id left join partners on partners.id = companies.partner_id ")
        .where("companies.delete_flg = 'false' and communications.mail_type = #{mail_type}")
    end

    def get_admin_student(mail_type)
        Communication::Communication.select('distinct (students.id) ')
        .joins("left join students on students.id = communications.user_id ")
        .joins("left join users on users.id = students.user_id")
        .where("communications.mail_type= #{mail_type} and students.delete_flg = 'false' ")
    end

end
