class Admin::CompanyManage::EventsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_event, only: %i[ event_edit event_update event_delete event_details]
  include CommonHelper
  layout 'layouts/template/admin'
 
    def event_search
      keyword = params[:keyword].blank? ? nil : params[:keyword].strip
      event_category_data = params[:category].blank? ? params[:category] = [] : "category && ARRAY#{params[:category].map(&:to_i)}"
      date_type = params[:date_type]
      startDate = params[:startDate].blank? ? nil : params[:startDate]
      endDate = params[:endDate].blank? ? nil : params[:endDate]
      if startDate.blank? && !endDate.blank?
        @event_list = Event.admin_company_event_search_by_only_end_date(date_type, endDate, keyword, [event_category_data])
      elsif(!startDate.blank? && endDate.blank?)
        @event_list = Event.admin_company_event_search_by_only_start_date(date_type, startDate, keyword, [event_category_data])
      elsif(!startDate.blank? && !endDate.blank?)
        @event_list = Event.admin_company_event_search_by_between_two_date(date_type, startDate, endDate, keyword, [event_category_data])   
      else
          @event_list = Event.admin_company_event_search_init_list(keyword, [event_category_data])
      end 
      @results_event = Kaminari.paginate_array(@event_list).page(params[:page]).per(12)
    end

    def event_details
    end

    def event_edit
      if @company_event.venue_types === 1
        @offline_sts = "1"
      elsif @company_event.venue_types === 2
        @online_sts = "1"
      else
        @both_sts = "1"
      end
    end

    def event_update
      respond_to do |format|
        if @company_event.update(event_params)
          # To delete upload image
          if params[:event][:imageFlag] == "true"
            @company_event.event_image.purge
          end
          unless params[:event][:image_data].eql?"false"
            blob = convert_Base64_imgData(params[:event][:image_data])
            @company_event.event_image.attach(blob)
            params[:event][:image_data] = false
          end
          format.html { redirect_to admin_company_manage_event_details_path(:id => @company_event.id), notice: "Event was successfully updated." }
          format.json { render :show, status: :ok, location: @company_event }
        else
          @event_venue_flag = "1"
          format.html { render :event_edit}
          format.json { render json: @company_event.errors, status: :unprocessable_entity }
        end
      end
    end

    def event_delete
      @company_event.update_columns(delete_flg: true)
      redirect_to admin_company_manage_event_search_path
    end

    private

    def set_admin_event
      @company_event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:event_image,:event_code, :event_start_date, :event_end_date, :event_name, :venue_types, :venue,:apply_event_limit,
        :post_start_date, :post_end_date, :application_start_date, :application_deadline, :event_content, :category=> [])
    end
  
end
