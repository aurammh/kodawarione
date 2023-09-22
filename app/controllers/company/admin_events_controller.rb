class Company::AdminEventsController < ApplicationController
  before_action :authenticate_company_user!
  skip_before_action :verify_authenticity_token
  authorize_resource class: 'Company::AdminEvent'

  def new
    @company_members =  Company::CompanyMember.select('company_members.user_id,company_users.first_name,company_users.last_name,company_users.email,company_members.department,company_members.position').joins(:company_users).where("company_members.company_id = '#{current_company.id}' AND company_members.join_flag = true AND company_members.user_id IS NOT NULL")
    admin_event_participant = Admin::EventParticipant.where(company_id: current_company.id , admin_event_id: params[:id])
    if admin_event_participant.present?
      @admin_event_participant = admin_event_participant.map{|member| member.company_user_id}
    else
      @admin_event_participant = []
    end
    @event_name = params[:ename]
    respond_to do |format|
      format.js {render 'company/admin_event/show_modal'}
      format.json { render json: @admin_event_participant.errors}
    end
  end

  def join_participant
    @event_details = Event.select('events.*').find(params[:id])
    @company_members =  Company::CompanyMember.select('company_members.id,company_members.user_id,company_users.first_name,company_users.last_name,company_users.email,company_members.department,company_members.position').joins(:company_users).where("company_members.company_id = '#{current_company.id}' AND company_members.join_flag = true AND company_members.user_id IS NOT NULL")
    admin_event_participant = Admin::EventParticipant.where(company_id: current_company.id , admin_event_id: params[:id])
    if admin_event_participant.present?
      @admin_event_participant = admin_event_participant.map{|member| member.company_user_id}
    else
      @admin_event_participant = []
    end
    @event_name = params[:ename]
    respond_to do |format|
      format.html { render "company/admin_event/join_participant_index" }
      format.json { head :no_content }
    end
  end

  def join_admin_events
    unless params[:user_id].nil?
      # get records form CompanyEvents:Table for apply_event_limit
      @admin_events = Event.find(params[:id])
      selected_users = params[:user_id].map(&:to_i)
      selected_users = selected_users.select {|x| x > 0}
      admin_event_participant = Admin::EventParticipant.where(company_id: current_company.id , admin_event_id: params[:id])
      # get counts form EventParticipant:Table f counts
      @apply_join_event_count = Admin::EventParticipant.where('admin_event_id = ? ', params[:id]).count
      @error_messages = true
      avaliable_count = @admin_events.apply_event_limit.to_i - @apply_join_event_count.to_i

      if admin_event_participant.present?
        avaliable_insert = true

        if selected_users.size === 0 
          admin_event_participant.destroy_all
          @error_messages = false
        end
        
        old_count = (@apply_join_event_count.to_i - admin_event_participant.size.to_i) + selected_users.size.to_i
        if old_count > @admin_events.apply_event_limit.to_i
          @error_messages = true
        else
          admin_event_participant.destroy_all
          selected_users.each do |attributes|
            if attributes > 0
              @admin_event_participant = Admin::EventParticipant.new(:admin_event_id => params[:id],:company_user_id => attributes,:company_id => current_company.id , :delete_flg => 'false',:partner_user_id => nil,:partner_id=> nil)
              @admin_event_participant.save!
              admin_event_date_update = Event.find_by(id: @admin_event_participant.admin_event_id , delete_flg: false)
              admin_event_date_update.update_columns(updated_at: Time.now )
            end
          end 
          @error_messages = false
        end
      else
        if selected_users.size <= avaliable_count
          selected_users.each do |attributes|
            if attributes > 0
              @admin_event_participant = Admin::EventParticipant.new(:admin_event_id => params[:id],:company_user_id => attributes,:company_id => current_company.id , :delete_flg => 'false', :partner_user_id => nil,:partner_id=> nil)
              @admin_event_participant.save!
              admin_event_date_update = Event.find_by(id: @admin_event_participant.admin_event_id , delete_flg: false)
              admin_event_date_update.update_columns(updated_at: Time.now )
            end
          end 
          @error_messages = false
        end
      end 
    end
      redirect_to company_admin_event_detail_search_path(id: params[:id], err_flag: @error_messages)
  end

  #Get admin event list for company-dashboard
  def admin_event_list
    # get admin event entry list
    @admin_event_result = Event.joins(:admin_event_participants).where("admin_event_participants.company_id =? AND admin_event_participants.delete_flg =? AND events.delete_flg =?",current_company.id, false,false).select("events.*, count(admin_event_participants.admin_event_id) as join_count").group(:id).order(updated_at: :desc)
    @admin_event_result = Kaminari.paginate_array(@admin_event_result).page(params[:page]).per(12)
    render "company/companies/list/admin_event_list"
  end
end