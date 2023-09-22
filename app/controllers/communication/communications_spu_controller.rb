class Communication::CommunicationsSpuController < ApplicationController
    before_action :authenticate_company_user!, if: :company_user_signed_in?
    before_action :authenticate_user!, if: :user_signed_in?
    include CommonHelper

    def spu_student_communication
        spu_id = @spu_data.super_partner_id
        spu_id_list = Partner::Partner.where(super_partner_id: spu_id).select('id').map{|item| item.id}.join(",")
        temps = [];
        # mail_type = 1111 => scotted , 2222 => direct message
        if params[:mail_type] == '1111' || params[:mail_type] == nil
            user_list = (Communication::Communication.new.get_spu_student(1,spu_id_list) )
            user_list.each do |student|
              @conversation_list = (Communication::Communication.new.get_all_communication(student.id,0,0,1,2)).sort_by(&:created_at).reverse
              @conversation_list.each do |conversation|
                temps.push(conversation)
              end
            end
            @conversation_list = temps
        else
            user_list = (Communication::Communication.new.get_spu_student(2,spu_id_list) )
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
        render 'communication/communications/spu_student_communication'
      end

    def spu_company_communication
        spu_id = @spu_data.super_partner_id
        spu_id_list = Partner::Partner.where(super_partner_id: spu_id).select('id').map{|item| item.id}.join(",")
        temps = [];
        # mail_type = 1111 => scotted , 2222 => direct message
        if params[:mail_type] == '1111' || params[:mail_type] == nil

        company_list = (Communication::Communication.new.get_spu_company(1,spu_id_list) )
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
        company_list = (Communication::Communication.new.get_spu_company(2,spu_id_list) )
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
        render 'communication/communications/spu_company_communication'
    end
end