module Student::StudentsHelper

    def school_type_options
        Student::Student.school_types.keys.map{ |k| [t("student.school_type.#{k}"), k] }
    end

    def subject_system_options
        Student::Student.subject_systems.keys.map{ |k| [t("student.subject_system.#{k}"), k] }
    end

    def is_beelab_activity_participate_options
        Student::Student.is_beelab_activity_participates.keys.map{ |k| [t("student.is_beelab_activity_participate.#{k}"), k] }
    end

    def gender_options
        Student::Student.genders.map { |k,v| [k, t("student.gender.#{k}")] }
    end

    def event_status_color(event, admin_event_participants)
        # puts event.status.instance_of? String
        if event.event_type === 1
            if event.status === '3' || event.status === '4'
                return false
            else
                return true
            end
        else
            if event.status != '4'
                admin_join_event = admin_event_participants.where(admin_event_id: event.id).count
                if admin_join_event < (event.apply_event_limit || 0)
                    return true
                else 
                    return false
                end
            else
                return false
            end
        end        
    end

    def event_status_text(event, admin_event_participants)
        if event.event_type === 1
            return event.status
        else
            if event.status != '4'
                admin_join_event = admin_event_participants.where(admin_event_id: event.id).count
                if admin_join_event < (event.apply_event_limit || 0)
                    return event.status
                else 
                    return '3'
                end
            else
                return '4'
            end
        end
    end
end