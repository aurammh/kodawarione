class Communication::CommunicationKodawarioneController < ApplicationController
    before_action :authenticate_admin!
    include CommonHelper
    layout 'layouts/template/kodawarione'

    def kodawarione_user_communication
        spu_id_list = Kodawarione::Partner.where(super_partner_id: current_admin.admin_member.super_partners_id).select('id').map{|item| item.id}.join(",")
        if spu_id_list.blank?
            spu_id_list = 0
        else
            spu_id_list
        end
        temps = [];
        # mail_type = 1111 => scotted , 2222 => direct message
        if params[:mail_type] == '1111' || params[:mail_type] == nil
            if current_admin.chief_administrator?
                user_list = (Communication::Communication.new.get_admin_student(1) )
            elsif current_admin.super_partner?
                user_list = (Communication::Communication.new.get_spu_student(1,spu_id_list) )
            elsif current_admin.partner?
                user_list = (Communication::Communication.new.get_student(1,current_admin.admin_member.partners_id) )
            end
            user_list.each do |student|
                @conversation_list = (Communication::Communication.new.get_all_communication(student.id,0,0,1,2)).sort_by(&:created_at).reverse
                @conversation_list.each do |conversation|
                temps.push(conversation)
                end
            end
            @conversation_list = temps
        else
            if current_admin.chief_administrator?
                user_list = (Communication::Communication.new.get_admin_student(2) )
            elsif current_admin.super_partner?
                user_list = (Communication::Communication.new.get_spu_student(2,spu_id_list) )
            elsif current_admin.partner?
                user_list = (Communication::Communication.new.get_student(2,current_admin.admin_member.partners_id) )
            end
            user_list.each do |student|
            @conversation_list = (Communication::Communication.new.get_all_communication(student.id,0,0,2,2)).sort_by(&:created_at).reverse
            @conversation_list.each do |conversation|
                temps.push(conversation)
            end
            end
            @conversation_list = temps
        end
        @conversation_list = Kaminari.paginate_array(@conversation_list).page(params[:page]).per(12)
        partner_new_communication_array(0)
        render 'communication/communications/kodawarione_user_communication'
    end

    def kodawarione_company_communication
        spu_id_list = Kodawarione::Partner.where(super_partner_id: current_admin.admin_member.super_partners_id).select('id').map{|item| item.id}.join(",")
        if spu_id_list.blank?
            spu_id_list = 0
        else
            spu_id_list
        end
        temps = [];
        # mail_type = 1111 => scotted , 2222 => direct message
        if params[:mail_type] == '1111' || params[:mail_type] == nil
            if current_admin.chief_administrator?
                company_list = (Communication::Communication.new.get_admin_company(1) )
            elsif current_admin.super_partner?
                company_list = (Communication::Communication.new.get_spu_company(1,spu_id_list) )
            elsif current_admin.partner?
                company_list = (Communication::Communication.new.get_company(1,current_admin.admin_member.partners_id) )
            end
            company_list.each do |company|
            @company_conversation_list = Communication::Communication.select('distinct(company_user_id)').where(company_id: company.id )
            @company_conversation_list.each do |company_conversation|
                @conversation_list = (Communication::Communication.new.get_all_communication(0,company_conversation.company_user_id,company.id, 1 ,1)).sort_by(&:created_at).reverse
                @conversation_list.each do |conversation|
                temps.push(conversation)
                end
            end
            end
            @conversation_list = temps
        else
            if current_admin.chief_administrator?
                company_list = (Communication::Communication.new.get_admin_company(2) )
            elsif current_admin.super_partner?
                company_list = (Communication::Communication.new.get_spu_company(2,spu_id_list) )
            elsif current_admin.partner?
                company_list = (Communication::Communication.new.get_company(2,current_admin.admin_member.partners_id) )
            end
            company_list.each do |company|
            @company_conversation_list = Communication::Communication.select('distinct(company_user_id)').where(company_id: company.id )
            @company_conversation_list.each do |company_conversation|
                @conversation_list = (Communication::Communication.new.get_all_communication(0,company_conversation.company_user_id,company.id, 2 ,1)).sort_by(&:created_at).reverse
                @conversation_list.each do |conversation|
                temps.push(conversation)
                end
            end
            end
        @conversation_list = temps
        end  
        @conversation_list = Kaminari.paginate_array(@conversation_list).page(params[:page]).per(12)
        partner_new_communication_array(0)     
        render 'communication/communications/kodawarione_company_communication'
    end
end