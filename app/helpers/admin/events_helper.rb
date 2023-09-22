module Admin::EventsHelper
    def admin_event_category_options
        Event.event_categories.map{ |k,v| [t("event.category.#{k}"),v] }
    end

    def admin_event_check_flag(admin_event_participant, company_member_id )
        admin_event_participant.each_with_index do |admin_company_member,index|
            if company_member_id.to_i === admin_company_member.to_i
                return true
            end 
        end
        return false
    end

    def kodawarione_event_show_options
        if current_admin.chief_administrator?
            Event.event_show_options.keys.map{ |k| [t("event.admin_event_show_options.#{k}"), k] }
        elsif current_admin.super_partner?
            Event.event_show_options.keys.last(4).map{ |k| [t("event.spu_event_show_options.#{k}"), k] }
        elsif current_admin.partner?
            Event.event_show_options.keys.last(3).map{ |k| [t("event.partner_event_show_options.#{k}"), k] }
        end   
    end

    def check_event_avaliable(event)
        event_joined = Admin::EventParticipant.where('admin_event_id = ? ', event.id).count
        if event_joined < (event.apply_event_limit || 0)
            return true
        else
            return false
        end
    end

    def super_partner_event_status_color(event)
        event_joined = Admin::EventParticipant.where('admin_event_id = ? ', event.id).count
        if event.status != '4'
            if event_joined < (event.apply_event_limit || 0)
                return true
            else
                return false
            end
        else
            return false
        end
    end

    def super_partner_event_status_text(event)
        event_joined = Admin::EventParticipant.where('admin_event_id = ? ', event.id).count
        if event.status != '4'
            if event.status === '1'
                return '1'
            else
                if event_joined < (event.apply_event_limit || 0)
                    return event.status
                else
                    return '3'
                end
            end
        else
            return '4'
        end
    end

    def check_event_join_avaliable(event)
        event_joined = Admin::EventParticipant.where('admin_event_id = ? ', event.id)
            if event_joined.count >= (event.apply_event_limit)
               if event_joined.exists?(company_id: current_company_user.company_member.company_id )
                    return true
                else
                    return false
                end
            else
                return true
            end
    end

    def check_event_join_avaliable_by_super(event, event_status)
        event_joined = Admin::EventParticipant.where('admin_event_id = ? ', event.id)
        if event_status === '1' || event_status === '4'
            return 2
        else
            if event_joined.count >= (event.apply_event_limit)
                if event_joined.exists?(super_partner_user_id: current_super_partner_user.id, super_partner_id: current_super_partner_user.super_partner_id )
                    return 1
                else
                    return 2
                end
            else
                if event_joined.exists?(super_partner_user_id: current_super_partner_user.id, super_partner_id: current_super_partner_user.super_partner_id )
                    return 1
                else
                    return 3
                end
            end
        end
    end

    def check_event_join_avaliable_by_partner(event, event_status)
        event_joined = Admin::EventParticipant.where('admin_event_id = ? ', event.id)
        if event_status === '1' || event_status === '4'
            return 2
        else
            if event_joined.count >= (event.apply_event_limit)
                if event_joined.exists?(partner_user_id: current_partner_user.id,partner_id: current_partner_user.partner_id )
                    return 1 # partner joined event
                else
                    return 2 # partner not allow event cuz' it full
                end
            else
                if event_joined.exists?(partner_user_id: current_partner_user.id,partner_id: current_partner_user.partner_id )
                    return 1 # partner joined event
                else
                    return 3 # partner enable to join
                end               
            end
        end
    end

    def check_event_wait_avaliable(event)
        is_full = false
        event_waited = 0
        event_joined = Admin::EventParticipant.where('admin_event_id = ? ', event.id)
        event_waited = EventWait.where('event_id = ? AND partner_id = ? AND partner_user_id = ?', event.id,current_partner_user.partner_id,current_partner_user.id).count
        #*** is event avaliable to join or not
        if event_joined.count >= (event.apply_event_limit)
            if event_joined.exists?(partner_user_id: current_partner_user.id,partner_id: current_partner_user.partner_id )
                is_full = false # partner joined event
            else
                is_full = true # partner not allow event cuz' it full
            end
        end
        
        # *** check event applicant full and is already padding in wait list
        if is_full && event_waited === 0
            return true
        else
            return false
        end
    end
end