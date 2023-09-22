class Company::SearchController < ApplicationController
    before_action :authenticate_company_user!
    include CommonHelper
    include Student::AssessmentsHelper
    authorize_resource class: 'Company::Search'

    def student_search
        @progress_percent_arr = current_company.progress_details.map {|obj| obj['percent']}
        # set previous path for breadcrumbs
        cookies[:previous_url] = '/company/students_search'
        student_address_query = ""
        company_favourite_query = ""
        gender_query  = ""

        #[student keyword search]
        keyword_query = search_params[:keyword].blank? ? search_params[:keyword] = [] : "lower(regexp_replace(regexp_replace(students.nick_name, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{search_params[:keyword].gsub(/'/, "''") }%')"
        #[student address search search]
        student_address_query = search_params[:address].blank? ? search_params[:address] = [] : "students.current_address = #{search_params[:address]}"
        #[preferred working address search]        
        preferred_working_address_query = search_params[:desired_location].blank? ? search_params[:desired_location] = [] : " students.preferred_working_area && ARRAY#{search_params[:desired_location].map(&:to_i)}"

        #[job type search]
        job_category_query = params[:jobcategory_id].blank? ? params[:jobcategory_id] = [] : "desire_job_type_id && ARRAY#{params[:jobcategory_id].map(&:to_i)}"

        #kodawari search
        # kodawari_query = params[:commitment_id].blank? ? params[:commitment_id] = [] : "ARRAY[CAST(student_commitment_ability_details.m_commitment_abilities_id AS INTEGER)] && ARRAY#{params[:commitment_id].map(&:to_i)}"

        #[delete_flag search with false]
        delete_flag_query =  "students.delete_flg = false"
        
        @temp_results = Company::Company.new.search_company_student([student_address_query,delete_flag_query],[keyword_query,job_category_query,preferred_working_address_query])
        @results = @temp_results.reject { |i| i.nick_name.nil? }
        favourite_company_current_student
        @results = Kaminari.paginate_array(@results).page(params[:page]).per(12)
        render "company/search/search_student"
    end

    #  Call by ajax to location deatils by m_region_id
    def getLocationDetails
        locationDetailList = MPrefecture.where(m_region_id: params[:m_region_id]).map { |locationDetail| [locationDetail.prefecture_name, locationDetail.id] }
        render json: locationDetailList.to_json
    end

    def student_details        
        @progress_percent_arr = current_company.progress_details.map {|obj| obj['percent']}
        @student_info = Student::Student.select('students.*,apply_favourite_transictions.company_id,apply_favourite_transictions.com_std_favourite').left_joins(:apply_favourite_transictions).find_by(user_id: params[:id])
        @student_assessment = Student::Assessment.find_by(student_id: params[:id])
        have_fav_student = ApplyFavouriteTransiction.find_by(student_id: @student_info.id, company_id: current_company.id)
        @fav_student = have_fav_student.nil? ? false : have_fav_student.com_std_favourite
        # For commitment chart
        # commitment_ability_chart(@student_info)
        #call radar chart one function
        selfEevaluationChart_rank(@student_assessment)
        #call radar chart two function
        potentialDesireType(@student_assessment)
        #call third function
        behavioralTraitTypeChart_rank(@student_assessment)
        # For commitment chart
        commitment_ability_chart(@student_info.user_id)
        unless @ability_list === [" "," "," "]
            @chart_commitment_label1 = @chart_commitment_label[0]
            @chart_commitment_label2 = @chart_commitment_label[1]
            @chart_commitment_label3 = @chart_commitment_label[2]
            @ability_list1 = @ability_list[0].name
            @ability_list2 = @ability_list[1].name
            @ability_list3 = @ability_list[2].name
            @ability_comment1 = @ability_list[0].ability_reason
            @ability_comment2 = @ability_list[1].ability_reason
            @ability_comment3 = @ability_list[2].ability_reason
        end
        @student_apply_status = VacancyApplyFavourite.where('company_id = ? and student_id = ? and apply_status = ? ', current_company.id, @student_info.id, 2)
        render "company/search/search_student_detail"        
    end

    # favourite_student by ajax
    def favourite_student
        userObj = current_company.apply_favourite_transictions.find_by(student_id: params[:id])
        if userObj.nil?
            userObj = ApplyFavouriteTransiction.new
            userObj.student_id = params[:id]
            userObj.company_id = current_company.id
            userObj.com_std_favourite = true
            userObj.action_date = DateTime.current.to_date
        else
            userObj.toggle!(:com_std_favourite)
            userObj.update_attribute(:action_date, Date.today)
        end
        userObj.save
        render :json => { :status => "ok", :com_std_favourite => userObj.com_std_favourite }
    end

    # join admin event by ajax
    def join_admin_event
        # get records form Events:Table for apply_event_limit
        @admin_event = Event.find(params[:id])
    
        # get counts form EventParticipant:Table f counts
        @apply_join_event_count = Admin::EventParticipant.where('admin_event_id = ? ', params[:id]).count
    
        # get records form EventParticipant:Table
        @applied_join_event = Admin::EventParticipant.find_by(company_id: current_company.id,
        admin_event_id: params[:id])
    
        if @applied_join_event.nil?
            if @apply_join_event_count < (@admin_event.apply_event_limit || 0)
                @applied_join_event = Admin::EventParticipant.new(
                  user_id: nil,
                  company_id: current_company.id,
                  company_user_id: current_company_user.id,
                  admin_event_id: params[:id],
                  delete_flg: false
                )
                @applied_join_event.save
                admin_event_date_update = Event.find_by(id: @applied_join_event.admin_event_id , delete_flg: false)
                admin_event_date_update.update_columns(updated_at: Time.now )
                render json: { status: 'ok', join_flag: true}
            else
                render json: { status: 'ok' , join_flag: false }
            end
        else
            @applied_join_event.destroy
            render json: { status: 'ok', join_flag: false }
        end
    end

    #show all admin search article list
    def search_article
        keyword = params[:keyword].blank? ? nil : params[:keyword].strip
        startDate = params[:startDate].blank? ? nil : params[:startDate]
        endDate = params[:endDate].blank? ? nil : params[:endDate]
        if startDate.blank? && !endDate.blank?
            @admin_article_result = Admin::Article.admin_article_search_by_date_to(endDate, keyword)
            elsif(!startDate.blank? && endDate.blank?)
            @admin_article_result = Admin::Article.admin_article_search_by_date_from(startDate, keyword)
            elsif(!startDate.blank? && !endDate.blank?)
            @admin_article_result = Admin::Article.admin_article_search_by_date_between(startDate, endDate, keyword)   
        else
            @admin_article_result = Admin::Article.admin_article_all_list(keyword)
        end 
        company_article_list = @admin_article_result.where("admin_articles.show_option = 1 OR admin_articles.show_option = 3")
        @results = Kaminari.paginate_array(company_article_list).page(params[:page]).per(12)
        render "company/search/search_admin_article"
    end

    def unjoin_event
        applied_join_event = ApplyFavouriteTransiction.find_by(student_id:params[:student_id], event_id: params[:event_id])
        applied_join_event.toggle!(:event_join) 
        applied_join_event.update_attribute(:action_date, Date.today)
        applied_join_event.save
        redirect_to company_join_event_student_list_path(:id => params[:event_id])
    end

    #search event those were created by admin
    def search_event
        # partner_id = current_company.partner_id
        # company_id = current_company.id

        # set previous path for breadcrumbs
        cookies[:previous_url] = "/company/search_event"
        event_category_data = if params[:category].blank?
                                params[:category] =
                                  []
                              else
                                "category && ARRAY#{params[:category].map(&:to_i)}"
                              end
        start_date_query = if params[:startDate].blank?
                                params[:startDate] = []
                               else
                                " events.event_start_date >= '#{params[:startDate]}'"
                               end
    
        end_date_query = if params[:endDate].blank?
                          params[:endDate] = []
                         else
                          " events.event_start_date <= '#{params[:endDate]}'"
                         end
    
        keyword_query = if params[:keyword].blank?
                          params[:keyword] =  []
                        else
                          "lower(regexp_replace(regexp_replace(events.event_name, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{params[:keyword].gsub(/'/, "''") }%')"
                        end 

        remove_past_event_query = params[:removePastEvent].nil? ?  " CURRENT_DATE >= events.post_start_date AND CURRENT_DATE <= events.post_end_date" :  "  CURRENT_DATE > events.application_deadline "
    
        # event_type_query = params[:event_type].blank? ? params[:event_type] = [] : "events.event_type = #{params[:event_type].to_i}"
    
        @results = Event.company_event_search_by_association([event_category_data,start_date_query,end_date_query,keyword_query,remove_past_event_query]).to_a
        join_admin_event_current_company
        @results = Kaminari.paginate_array(@results).page(params[:page]).per(12)
        render "company/search/search_admin_event"
    end

    #view detail event when click on corresponding event
    def admin_event_detail_search
        @company_members =  Company::CompanyMember.select('company_members.user_id,company_users.first_name,company_users.last_name,company_users.email,company_members.department,company_members.position').joins(:company_users).where("company_members.company_id = '#{current_company.id}' AND company_members.join_flag = true")
        @event_details = Event.select('events.*').find(params[:id])

        if @event_details.event_type == 3
            @event_details = Event.select('events.*').find(params[:id])
        elsif @event_details.event_type == 2
            @event_details = Event.select('events.*').find(params[:id])
        end

        j_event = @event_details.admin_event_participants.where(company_id: current_company.id)
        @join_event = j_event.present? ? true : false
        # @admin_event_participants = Admin::EventParticipant.joins("INNER JOIN company_members on company_members.user_id = admin_event_participants.company_user_id").where("admin_event_participants.admin_event_id =? AND admin_event_participants.company_id =? AND admin_event_participants.delete_flg =?",@event_details.id, current_company.id, false).select("admin_event_participants.*, company_members.*").order(updated_at: :desc)
        @admin_event_participants = Company::CompanyMember.joins("INNER JOIN admin_event_participants on company_members.user_id = admin_event_participants.company_user_id").where("admin_event_participants.admin_event_id =? AND admin_event_participants.company_id =? AND admin_event_participants.delete_flg =?",@event_details.id, current_company.id, false).select('company_members.id,company_members.user_id,company_users.first_name,company_users.last_name,company_members.company_roles_id,company_users.email,company_members.department,company_members.position,company_members.join_flag').joins(:company_users).where("company_members.company_id = '#{current_company.id}' AND company_members.join_flag = true AND company_members.user_id IS NOT NULL")
        render "company/search/search_admin_event_detail"
    end

    #search article details those were created by admin
    def search_admin_article_detail
        @admin_article = Admin::Article.find(params[:id])
        if @admin_article.video_link.present?
            @admin_article_video = Kaminari.paginate_array(@admin_article.video_link).page(params[:page]).per(4)
        end
        render "company/search/search_admin_article_detail"
    end

private
    def search_params
        params.permit(:address, :m_region_id, :desire_job_id, :puppy, :gender, :keyword, industry: [], status: [], jobcategory_id: [], locationDetail_id: [], desired_location: [], commitment_id: [])
    end

    def favourite_company_current_student
        @student_favourite_arr = []
        student_favourite = current_company.apply_favourite_transictions.where(com_std_favourite: true)
        @student_favourite_arr = student_favourite.map{|data| data.student_id} unless @student_favourite.present?
    end

    def join_admin_event_current_company
        @join_event_arr = []
        join_event = current_company.admin_event_participants.where.not(company_id: nil)
        @join_event_arr = join_event.map{|data| data.admin_event_id} unless @join_event.present?
    end
 
end