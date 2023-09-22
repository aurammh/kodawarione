class Kodawarione::EventController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_admin_self_event, only: %i[show event_edit admin_self_event_update admin_self_event_delete event_joined_by_user event_joined_by_spu event_joined_by_partner event_joined_by_company]
    include CommonHelper
    layout 'layouts/template/kodawarione'
    load_and_authorize_resource

    def event_list
        keyword = params[:keyword].blank? ? nil : params[:keyword].strip
        event_category_data = params[:category].blank? ? params[:category] = [] : "category && ARRAY#{params[:category].map(&:to_i)}"
        date_type = params[:date_type]
        startDate = params[:startDate].blank? ? nil : params[:startDate]
        endDate = params[:endDate].blank? ? nil : params[:endDate]
        if startDate.blank? && !endDate.blank?
            @admin_event_result = Event.admin_admin_event_search_by_only_end_date(date_type, endDate, keyword, [event_category_data]).where(query_with_current_role("events", "event_list"))
        elsif(!startDate.blank? && endDate.blank?)
            @admin_event_result = Event.admin_admin_event_search_by_only_start_date(date_type, startDate, keyword, [event_category_data]).where(query_with_current_role("events", "event_list"))
        elsif(!startDate.blank? && !endDate.blank?)
            @admin_event_result = Event.admin_admin_event_search_by_between_two_date(date_type, startDate, endDate, keyword, [event_category_data]).where(query_with_current_role("events", "event_list"))   
        else
            @admin_event_result = Event.admin_admin_event_search_init_list(keyword, [event_category_data]).where(query_with_current_role("events", "event_list"))
        end 
            @results = Kaminari.paginate_array(@admin_event_result).page(params[:page]).per(12)
    end

    def new
        @admin_event = Event.new
        @offline_sts = "1"
    end

    def show
    end

    def create
        @admin_event = Event.new(admin_event_params)
        @admin_event.event_type = 3
        @admin_event.created_by_id = current_admin.id
        @admin_event.created_user_id = current_admin.id
        # @admin_event.admins_id= current_admin.id
        count=Event.count+1
        @admin_event.event_code = "#{(Date.today + 6).year % 100}-#{count.to_s.rjust(5, "0")}"

        respond_to do |format|
            if @admin_event.save
            save_img
            format.html { redirect_to kodawarione_event_list_path}
            format.json { render :show, status: :created, location: @admin_event }
            else
            format.html { render :new}
            format.json { render json: @admin_event.errors, status: :unprocessable_entity }
            end
        end
    end

    def event_edit
        if @admin_event.venue_types === 1
          @offline_sts = "1"
        elsif @admin_event.venue_types === 2
          @online_sts = "1"
        else
          @both_sts = "1"
        end
    end

    def admin_self_event_update
        respond_to do |format|
          if @admin_event.update(admin_event_params)
            # To delete upload image
            if params[:event][:imageFlag] == "true"
              @admin_event.event_image.purge
            end
            save_img
            format.html { redirect_to kodawarione_event_list_path, notice: "Event was successfully updated." }
            format.json { render :show, status: :ok, location: @admin_event }
          else
            @event_venue_flag = "1"
            format.html { render :event_edit}
            format.json { render json: @admin_event.errors, status: :unprocessable_entity }
          end
        end
    end
    
    def save_img
        unless params[:event][:image_data].eql?"false"
            blob = convert_Base64_imgData(params[:event][:image_data])
            @admin_event.event_image.attach(blob)
            params[:event][:image_data] = false
        end
    end
    
    def admin_self_event_delete
        @admin_event.update_columns(delete_flg: true)
        @admin_event.admin_event_participants.update_all(delete_flg: true)
        redirect_to kodawarione_event_list_path
    end

    # Super Partner Participatns search and details
    def event_joined_by_spu
        admin_event_id = params[:admin_event_id]    
        event_id = params[:id]
        super_partner_name_keyword = params[:super_partner_name_keyword].blank? ? nil : params[:super_partner_name_keyword].strip
        event_name_keyword = params[:event_name_keyword].blank? ? nil : params[:event_name_keyword].strip
        @event = Event.find_by(id: event_id).present? ?  Event.find_by(id: event_id) : nil
        if event_id.present?
        @super_participants_list =  Admin::EventParticipant.super_partner_participants_for_admin_events_all_lists(event_id, super_partner_name_keyword)
        elsif admin_event_id.present?
        @super_participants_list =  Admin::EventParticipant.super_partner_participants_for_admin_events_all_lists(admin_event_id, super_partner_name_keyword)
        end
        @super_participants_list = Kaminari.paginate_array(@super_participants_list).page(params[:page]).per(12)
        # respond_to do |format|
        # format.html
        # format.xlsx { render xlsx:t('event_participant.title.super_partner_event_participant'), template: 'admin/excel_template/super_partner_participants_export'}
        # end
    end

    # Student Participants search
    def event_joined_by_user
        event_id = params[:id]
        admin_event_id = params[:admin_event_id]
        user_name_keyword = params[:user_name_keyword].blank? ? nil : params[:user_name_keyword].strip
        @event = Event.find_by(id: event_id).present? ?  Event.find_by(id: event_id) : nil
        if event_id.present?
        @user_event_participants_list = Admin::EventParticipant.user_participants_for_admin_events_all_lists(event_id, user_name_keyword)
        elsif admin_event_id.present?
        @user_event_participants_list = Admin::EventParticipant.user_participants_for_admin_events_all_lists(admin_event_id, user_name_keyword)
        end
        @user_event_participants_list = Kaminari.paginate_array(@user_event_participants_list).page(params[:page]).per(12)
        # respond_to do |format|
        # format.html
        # format.xlsx { render xlsx: t('event_participant.title.user_event_participant'), template: 'admin/excel_template/user_event_participants_export'}
        # end
    end

    # Partner Participants search and details
    def event_joined_by_partner
        event_id = params[:id]
        admin_event_id = params[:admin_event_id]
        partner_name_keyword = params[:partner_name_keyword].blank? ? nil : params[:partner_name_keyword].strip
        @event = Event.find_by(id: event_id).present? ?  Event.find_by(id: event_id) : nil 
        if event_id.present?
        @partner_event_participants_lists = Admin::EventParticipant.partner_participants_for_admin_events_all_lists(event_id, partner_name_keyword)
        elsif admin_event_id.present?
        @partner_event_participants_lists = Admin::EventParticipant.partner_participants_for_admin_events_all_lists(admin_event_id, partner_name_keyword)
        end
        @partner_event_participants_lists = Kaminari.paginate_array(@partner_event_participants_lists).page(params[:page]).per(12)
        # respond_to do |format|
        # format.html
        # format.xlsx { render xlsx:t('event_participant.title.partner_event_participant'), template: 'admin/excel_template/partner_participants_export'}
        # end
    end

    # Company Participants search and details
    def event_joined_by_company
        admin_event_id = params[:admin_event_id]
        event_id = params[:id]
        company_name_keyword = params[:company_name_keyword].blank? ? nil : params[:company_name_keyword].strip
        event_name_keyword = params[:event_name_keyword].blank? ? nil : params[:event_name_keyword].strip
        @event = Event.find_by(id: event_id).present? ?  Event.find_by(id: event_id) : nil 
        if event_id.present?
        @com_event_participants_list =  Admin::EventParticipant.company_participants_for_admin_events_all_lists(event_id, company_name_keyword, event_name_keyword)
        elsif admin_event_id.present?
        @com_event_participants_list =  Admin::EventParticipant.company_participants_for_admin_events_all_lists(admin_event_id, company_name_keyword, event_name_keyword)
        end
        @com_event_participants_list = Kaminari.paginate_array(@com_event_participants_list).page(params[:page]).per(12)
        # respond_to do |format|
        # format.html
        # format.xlsx { render xlsx:t('event_participant.title.company_event_participant'), template: 'admin/excel_template/event_participants_export'}
        # end
    end

    private
  
    def set_admin_self_event
        @admin_event = Event.find(params[:id])
    end

    def admin_event_params
        params.require(:event).permit(:event_image, :event_code, :venue_types, :event_start_date, :event_end_date, :event_name, :venue, :apply_event_limit, :event_show_option,
        :post_start_date, :post_end_date, :application_start_date, :application_deadline, :event_content, :category=> [])
    end
end