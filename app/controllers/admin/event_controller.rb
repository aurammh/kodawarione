class Admin::EventController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_events, only: %i[ admin_event_edit admin_event_update]
  include CommonHelper
  layout 'layouts/template/admin'

  def index
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    event_category_data = params[:category].blank? ? params[:category] = [] : "category && ARRAY#{params[:category].map(&:to_i)}"
    date_type = params[:date_type]
    startDate = params[:startDate].blank? ? nil : params[:startDate]
    endDate = params[:endDate].blank? ? nil : params[:endDate]
    if startDate.blank? && !endDate.blank?
      @admin_event_result = Event.admin_admin_event_search_by_only_end_date(date_type, endDate, keyword, [event_category_data])
    elsif(!startDate.blank? && endDate.blank?)
      @admin_event_result = Event.admin_admin_event_search_by_only_start_date(date_type, startDate, keyword, [event_category_data])
    elsif(!startDate.blank? && !endDate.blank?)
      @admin_event_result = Event.admin_admin_event_search_by_between_two_date(date_type, startDate, endDate, keyword, [event_category_data])   
    else
      @admin_event_result = Event.admin_admin_event_search_init_list(keyword, [event_category_data])
    end 
      @results = Kaminari.paginate_array(@admin_event_result).page(params[:page]).per(12)
  end

  # Super Partner Participatns search and details
  def super_partner_participants_search
    admin_event_id = params[:admin_event_id]    
    event_id = params[:id]
    super_partner_name_keyword = params[:super_partner_name_keyword].blank? ? nil : params[:super_partner_name_keyword].strip
    event_name_keyword = params[:event_name_keyword].blank? ? nil : params[:event_name_keyword].strip
    if event_id.present?
      @super_participants_list =  Admin::EventParticipant.super_partner_participants_for_admin_events_all_lists(event_id, super_partner_name_keyword)
    elsif admin_event_id.present?
      @super_participants_list =  Admin::EventParticipant.super_partner_participants_for_admin_events_all_lists(admin_event_id, super_partner_name_keyword)
    end
    respond_to do |format|
      format.html
      format.xlsx { render xlsx:t('event_participant.title.super_partner_event_participant'), template: 'admin/excel_template/super_partner_participants_export'}
    end
  end

  def super_partner_participants_details
    super_partner_id = params[:super_partner_id]
    admin_event_id = params[:admin_event_id]
    @super_partner_participant_details = Admin::EventParticipant.super_partner_participants_for_admin_events_detail_list(super_partner_id, admin_event_id)
    @super_partner = Admin::SuperPartner.find(super_partner_id)
  end

  # Partner Participants search and details
  def partner_user_event_participants_search
    event_id = params[:id]
    admin_event_id = params[:admin_event_id]
    partner_name_keyword = params[:partner_name_keyword].blank? ? nil : params[:partner_name_keyword].strip    
    if event_id.present?
      @partner_event_participants_lists = Admin::EventParticipant.partner_participants_for_admin_events_all_lists(event_id, partner_name_keyword)
    elsif admin_event_id.present?
      @partner_event_participants_lists = Admin::EventParticipant.partner_participants_for_admin_events_all_lists(admin_event_id, partner_name_keyword)
    end
    respond_to do |format|
      format.html
      format.xlsx { render xlsx:t('event_participant.title.partner_event_participant'), template: 'admin/excel_template/partner_participants_export'}
    end
  end

  def partner_participant_details
    participant_partner_id = params[:participant_partner_id]
    participant_event_id = params[:participant_event_id]
    @partner_participant_details = Admin::EventParticipant.partner_participants_for_admin_events_detail_list(participant_partner_id, participant_event_id)
    @participants_partner = Partner::Partner.find(participant_partner_id)
  end

  # Company Participants search and details
  def event_participants_search
    admin_event_id = params[:admin_event_id]
    event_id = params[:id]
    company_name_keyword = params[:company_name_keyword].blank? ? nil : params[:company_name_keyword].strip
    event_name_keyword = params[:event_name_keyword].blank? ? nil : params[:event_name_keyword].strip
    if event_id.present?
      @event_participants_list =  Admin::EventParticipant.company_participants_for_admin_events_all_lists(event_id, company_name_keyword, event_name_keyword)
    elsif admin_event_id.present?
      @event_participants_list =  Admin::EventParticipant.company_participants_for_admin_events_all_lists(admin_event_id, company_name_keyword, event_name_keyword)
    end
    respond_to do |format|
      format.html
      format.xlsx { render xlsx:t('event_participant.title.company_event_participant'), template: 'admin/excel_template/event_participants_export'}
    end
  end

  def event_participants_details
    participants_company_id = params[:participants_company_id]
    participants_event_id = params[:participants_event_id]
    @event_participants_company_details = Admin::EventParticipant.company_participants_for_admin_events_details_list(participants_company_id, participants_event_id)
    @participants_company = Company::Company.select('companies.*,m_industries.industry_name').left_outer_joins(:m_industries).find(participants_company_id)
  end

  # Student Participants search
  def user_event_participants_search
    event_id = params[:id]
    admin_event_id = params[:admin_event_id]
    user_name_keyword = params[:user_name_keyword].blank? ? nil : params[:user_name_keyword].strip    
    if event_id.present?
      @user_event_participants_list = Admin::EventParticipant.user_participants_for_admin_events_all_lists(event_id, user_name_keyword)
    elsif admin_event_id.present?
      @user_event_participants_list = Admin::EventParticipant.user_participants_for_admin_events_all_lists(admin_event_id, user_name_keyword)
    end
    respond_to do |format|
      format.html
      format.xlsx { render xlsx: t('event_participant.title.user_event_participant'), template: 'admin/excel_template/user_event_participants_export'}
    end
  end

  def admin_event_details
    @admin_event = Event.find(params[:id])
  end

  # GET /admin/events/new
  def new
    @admin_event = Event.new
    @offline_sts = "1"
  end


  # POST /admin/events
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
        format.html { redirect_to admin_event_index_path}
        format.json { render :show, status: :created, location: @admin_event }
      else
        format.html { render :new}
        format.json { render json: @admin_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def admin_event_edit
    if @admin_event.venue_types === 1
      @offline_sts = "1"
    elsif @admin_event.venue_types === 2
      @online_sts = "1"
    else
      @both_sts = "1"
    end
  end

  def admin_event_update
    respond_to do |format|
      if @admin_event.update(admin_event_params)
        # To delete upload image
        if params[:event][:imageFlag] == "true"
          @admin_event.event_image.purge
        end
        save_img
        format.html { redirect_to admin_event_index_path, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_event }
      else
        @event_venue_flag = "1"
        format.html { render :admin_event_edit}
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

  def admin_event_delete
    admin_event_obj = Event.find(params[:id])
    admin_event_obj.update_columns(delete_flg: true)
    admin_event_obj.admin_event_participants.update_all(delete_flg: true)
    redirect_to admin_event_index_path
  end

  private
  
  def set_admin_events
    @admin_event = Event.find(params[:id])
  end

  def admin_event_params
    params.require(:event).permit(:event_image, :event_code, :venue_types, :event_start_date, :event_end_date, :event_name, :venue, :apply_event_limit, :event_show_option,
    :post_start_date, :post_end_date, :application_start_date, :application_deadline, :event_content, :category=> [])
  end
end
