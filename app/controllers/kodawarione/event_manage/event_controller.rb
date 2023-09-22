class Kodawarione::EventManage::EventController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_admin_event, only: %i[search_event_detail event_apply_student_list]
    authorize_resource class: 'Kodawarione::EventManage'
    include CommonHelper
    layout 'layouts/template/kodawarione'

    def search_event
        keyword = params[:keyword].blank? ? nil : params[:keyword].strip
        event_category_data = params[:category].blank? ? params[:category] = [] : "category && ARRAY#{params[:category].map(&:to_i)}"
        date_type = params[:date_type]
        startDate = params[:startDate].blank? ? nil : params[:startDate]
        endDate = params[:endDate].blank? ? nil : params[:endDate]
        if startDate.blank? && !endDate.blank?
          @event_list = Event.event_search_by_only_end_date(date_type, endDate, keyword, [event_category_data]).where(query_with_current_role("events", "event_search"))
        elsif(!startDate.blank? && endDate.blank?)
          @event_list = Event.event_search_by_only_start_date(date_type, startDate, keyword, [event_category_data]).where(query_with_current_role("events", "event_search"))
        elsif(!startDate.blank? && !endDate.blank?)
          @event_list = Event.event_search_by_between_two_date(date_type, startDate, endDate, keyword, [event_category_data]).where(query_with_current_role("events", "event_search"))  
        else
            @event_list = Event.event_search_init_list(keyword, [event_category_data]).where(query_with_current_role("events", "event_search"))
        end  
        @results_event = Kaminari.paginate_array(@event_list).page(params[:page]).per(12) 
    end

    def search_event_detail  
    end

    def event_apply_student_list
      @event = Event.find_by(id: params[:id]).present? ?  Event.find_by(id: params[:id]) : nil
      @join_event_list = Event.new.apply_event_student_list(params[:id])
      @join_event_list = Kaminari.paginate_array(@join_event_list).page(params[:page]).per(12)
    end

    private

    def set_admin_event
      @company_event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:event_image,:event_code, :event_start_date, :event_end_date, :event_name, :venue,:apply_event_limit,
        :post_start_date, :post_end_date, :application_start_date, :application_deadline, :event_content, :category=> [])
    end
end