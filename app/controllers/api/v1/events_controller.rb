class Api::V1::EventsController < Api::V1::ApplicationController
  
  # GET /company/events or /company/events.json
  def index
    company_events_images = Array.new
    company_events = Event.all
    #company = Company::Company.all.map { |company| [company.id , company.company_name]}.to_h
    
    company_events.each do |event|

      if event.category.any?
        event_category = event.category.select { |item| nil != item }
        category_name =  event_category.map{|category| 
           [t("event.category.#{Event.event_categories.key(category)}")]
        }.join(', ')
      end

      if event.event_image.attached?
        img_url =  url_for(event.event_image)
      else
        img_url =  'not found'
      end

      #company_name = company[event.company_id]
      event = event.attributes
      event = event.as_json(only: %i[event_code event_name event_start_date event_end_date venue post_start_date post_end_date application_deadline event_content delete_flg created_at updated_at apply_event_limit])
      event['category_name'] = category_name
      #event['company_name'] = company_name
      event['image_url'] = img_url
      company_events_images << event
      end
    render json: company_events_images
  end
end