class Company::EventsController < ApplicationController
  before_action :authenticate_company_user!
  before_action :set_company_event, only: %i[ show edit update destroy event_apply_list]
  load_and_authorize_resource param_method: :company_event_params
  include CommonHelper
  # GET /company/events or /company/events.json
  def index
    # set previous path for breadcrumbs
    cookies[:previous_url] = '/company/events'
    @company_events = Company::Company.new.get_event_entry_list(current_company.id)
    @student_join_event = Company::Company.new.get_join_event_student_count(current_company.id)
    get_hash_value(@student_join_event)
    @company_events = Kaminari.paginate_array(@company_events).page(params[:page]).per(12)
  end

  # GET /company/events/1 or /company/events/1.json
  def show
    @event = Event.find_by(id: params[:id]).present? ?  Event.find_by(id: params[:id]) : nil
  end

  # GET /company/events/new
  def new
    #permission_url
    @company_event = Event.new 
    @offline_sts = "1" 
  end

  # GET /company/events/1/edit
  def edit
    if @company_event.venue_types === 1
      @offline_sts = "1"
    elsif @company_event.venue_types === 2
      @online_sts = "1"
    else
      @both_sts = "1"
    end
  end

  # POST /company/events or /company/events.json
  def create
    @company_event = Event.new(company_event_params)
    @company_event.event_type = 1
    @company_event.event_show_option = 2
    @company_event.created_by_id = current_company.id
    @company_event.created_user_id = current_company.id
    count=Event.count+1
    @company_event.event_code = "#{(Date.today + 6).year % 100}-#{count.to_s.rjust(5, "0")}"
    respond_to do |format|
      if @company_event.save
        save_img
        format.html { redirect_to company_events_path}
        format.json { render :show, status: :created, location: @company_event }
        flash[:success] = [t('common.create_success'), t('event.title.event_information')]
      else
        @event_venue_flag = "1"
        format.html { render :new}
        format.json { render json: @company_event.errors, status: :unprocessable_entity }
        flash[:error] = [t('common.create_error'), t('event.title.event_information')]
      end
    end
  end

  # PATCH/PUT /company/events/1 or /company/events/1.json
  def update
    respond_to do |format|
      if @company_event.update(company_event_params)
        # To delete upload image
        if params[:event][:imageFlag] == "true"
          @company_event.event_image.purge
        end
        save_img
        format.html { redirect_to company_events_path, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @company_event }
        flash[:success] = [t('common.update_success'), t('event.title.event_information')]
      else
        @event_venue_flag = "1"
        format.html { render :edit}
        format.json { render json: @company_event.errors, status: :unprocessable_entity }
        flash[:error] = [t('common.update_error'), t('event.title.event_information')]
      end
    end
  end

  def save_img
    unless params[:event][:image_data].eql?"false"
      blob = convert_Base64_imgData(params[:event][:image_data])
      @company_event.event_image.attach(blob)
      params[:event][:image_data] = false
    end
  end

  # Event apply list
  def event_apply_list
    @event = Event.find_by(id: params[:id]).present? ?  Event.find_by(id: params[:id]) : nil
    @join_event_list = Company::Company.new.get_joined_event_student_list(params[:id])
    @join_event_list = Kaminari.paginate_array(@join_event_list).page(params[:page]).per(12)
    render 'company/events/list/event_apply_list'
  end
  # DELETE /company/events/1 or /company/events/1.json
  def destroy
    @company_event.destroy
    respond_to do |format|
      format.html { redirect_to company_events_path, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  #show past/finished event lists
  def select_past_events
    # set previous path for breadcrumbs
    cookies[:previous_url] = '/company/select_past_events'
    @past_events = Event.search_past_event(current_company.id)
    @student_join_event = Company::Company.new.get_join_event_student_count(current_company.id)
    get_hash_value(@student_join_event)
    @past_events = Kaminari.paginate_array(@past_events).page(params[:page]).per(12)
    render "company/companies/list/published_event_list"
  end

  private
    def permission_url
      unless check_permission?(current_company_user.id,'event_create')
        redirect_to company_companies_path
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_company_event
      @company_event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_event_params
      params.require(:event).permit(:event_image,:event_code, :event_start_date, :event_end_date, :event_name, :venue, :venue_types, :apply_event_limit,
      :post_start_date, :post_end_date, :application_start_date, :application_deadline, :event_content, :category=> [])
    end
end