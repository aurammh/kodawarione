module Company::EventsHelper
    def event_category_options
        Event.event_categories.map{ |k,v| [t("event.category.#{k}"),v] }
    end

    # check current user to show or hide jion icon at detail page
    def check_join_event_is_current_user_or_not(event_id,application_start_date,application_deadline,applied_join_events)
        participated_event_array= applied_join_events.where("event_id = ? AND event_join = ?",event_id,true)
        enable_joint_date = true
        unless application_start_date.nil?
            enable_joint_date = Date.today.between?(application_start_date, application_deadline)
        end
        if participated_event_array.exists?(student_id: current_user.student.id ) && enable_joint_date
            return true
        else
            return false
        end
    end

    def check_admin_event_details(event, admin_event_joined)
        enable_joint_date = true
        unless event.application_start_date.nil?
            enable_joint_date = Date.today.between?(event.application_start_date, event.application_deadline)
        end
        if event.status === 4
            return false
        else
            if admin_event_joined.exists?(user_id: current_user.id) && enable_joint_date
                return true
            elsif admin_event_joined.count < (event.apply_event_limit || 0) 
                return true
            else
                return false
            end
        end
    end

    def event_options
        Event.event_show_options.keys.map{ |k| [t("admin.event.event_show_options.#{k}"), k] }
    end

    def venue_type_options
        Event.venue_types.keys.map{ |k| [t("event.venue_types.#{k}"), k] }
    end
end