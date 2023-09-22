class EventWait::EventWaitController < ApplicationController
    def create_event_wait
        event_wait = EventWait.new
        event_wait.event_id = params[:event_id]
        event_wait.join_user_type = params[:join_user_type]
        if params[:join_user_type] === "1" #company
            event_wait.company_id =  params[:join_parent_user_id]
            event_wait.company_user_id =  params[:join_user_id]

        elsif params[:join_user_type] === "2" #student
            event_wait.user_id =  params[:join_user_id]

        elsif params[:join_user_type] === "3" #partner
            event_wait.partner_id =  params[:join_parent_user_id]
            event_wait.partner_user_id =  params[:join_user_id]

        elsif params[:join_user_type] === "4" #admin  
            event_wait.admin =  params[:join_user_id]

        elsif params[:join_user_type] === "5" #super_partner   
            event_wait.super_partner_id =  params[:join_parent_user_id]
            event_wait.super_partner_user_id =  params[:join_user_id]
        end
        event_wait.join_date = Time.now
        event_wait.save
        render :json => { :status => "ok", :falg => true }
    end
end