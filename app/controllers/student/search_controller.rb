class Student::SearchController < ApplicationController
  before_action :authenticate_user!, :authorize_user!
  before_action :similar_companies, only: %i[company_detail_home company_detail_about company_detail_job company_detail_event company_detail_member]
  before_action :set_company_vacancy, only: %i[ search_vacancy_detail ]
  include CommonHelper
  def company_search
    industry_query = if params[:industry_id].blank?
                       params[:industry_id] =
                         []
                     else
                       "companies.m_industry_id = '#{params[:industry_id]}'"
                     end
    prefecture_query = if params[:prefecture_id].blank?
                      params[:prefecture_id] =
                        []
                    else
                      "companies.m_prefecture_id = '#{params[:prefecture_id]}'"
                    end
    keyword_query = if params[:keyword].blank?
                      params[:keyword] =  []
                    else
                      "lower(regexp_replace(regexp_replace(companies.company_name, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{params[:keyword].gsub(/'/, "''") }%')"
                    end
    @companies = Student::Student.company_search_by_association([industry_query,prefecture_query,keyword_query])
    favourite_company_current_student
    @companies = Kaminari.paginate_array(@companies).page(params[:page]).per(12)
    render 'student/search/search_company'
  end

  def favourite_company
    @applied_favourite = ApplyFavouriteTransiction.find_by(student_id: current_user.student.id,
                                                           company_id: params[:id])
    if @applied_favourite.nil?
      @applied_favourite = ApplyFavouriteTransiction.new(student_id: current_user.student.id, company_id: params[:id], job_id: nil,
                                                         std_com_favourite: true, std_job_favourite: false, com_std_favourite: false, std_job_apply: false, action_date: Date.today)
    else
      @applied_favourite.toggle!(:std_com_favourite)
      @applied_favourite.update_attribute(:action_date, Date.today)
    end
    @applied_favourite.save
    render json: { status: 'ok', favourite_flag: @applied_favourite.std_com_favourite }
  end

  # Part of Vacancy Search
  def vacancy_search
    # set previous path for breadcrumbs
    cookies[:previous_url] = "/student/vacancy_search"
    industry_query = if params[:industry_id].blank?
                       params[:industry_id] =
                         []
                     else
                       "recruit_industry_type = '#{params[:industry_id]}'"
                     end
    job_type_query = if params[:job_type_id].blank?
                       params[:job_type_id] =
                         []
                     else
                       "recruit_job_type = '#{params[:job_type_id]}'"
                     end
    keyword_query = if params[:keyword].blank?
                      params[:keyword] =  []
                    else
                      "lower(regexp_replace(regexp_replace(company_vacancies.vacancy_title, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{params[:keyword].gsub(/'/, "''") }%')"
                    end
    # promotion_query = params[:promotion].nil? ? params[:promotion] = [] : "promotion = '#{params[:promotion]}'"
    # overtime_query = params[:overtime].nil? ? params[:overtime] = [] : "over_time = '#{params[:overtime]}'"
    area_query = params[:region_id].blank? ? params[:region_id] = [] : "company_vacancies.m_region_id = '#{params[:region_id]}'"
    prefecture_query = params[:prefecture_id].blank? ? params[:prefecture_id] = [] : "company_vacancies.m_prefecture_id = '#{params[:prefecture_id]}'"
    @vacancies = Student::Student.vacancy_search_by_association([industry_query, job_type_query, keyword_query, prefecture_query,
                                                                 area_query])
    favourite_vacancy_current_student
    apply_vacancy_current_student
    @vacancies = Kaminari.paginate_array(@vacancies).page(params[:page]).per(12)
    render 'student/search/search_vacancy'
  end

  def search_vacancy_detail
    @company_vacancy_list = Company::Vacancy.left_outer_join_application_status_transactions(current_user.student.id).select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,application_status_transactions.status')
    .joins(:m_industries,:m_occupations).where(id: params[:id]).take

    @welfare_list =
    if @company_vacancy_list.welfare_list_data.present?
      welfare_list = @company_vacancy_list.welfare_list_data.select { |item| nil != item}
      welfare_data_index =  welfare_list.each_index.select { |i| welfare_list[i]== 1 }.map!{|element| element.is_a?(Integer) ? element + 1 : element}
      if welfare_data_index.any?
        #MWelfareDetail.where("id IN (#{welfare_data_index.join(',')})").map { |wf| [wf.welfare_type]}.join(', ')
        MWelfareDetail.where("id IN (#{welfare_data_index.join(',')})")
      end
    end
    #get favorite vacancy list by student
    unless check_user_type == LogoutHistory.active_types["company"].to_i
      favorite_vacancy = @company_vacancy_list.vacancy_apply_favourites.where(favourite_flg: true,student_id: current_user.student.id)
      @fav_vacancy = favorite_vacancy.present? ? true :false
    end
     #get apply vacancy list by student
     unless check_user_type == LogoutHistory.active_types["company"].to_i
      apply_vacancy = @company_vacancy_list.vacancy_apply_favourites.where(apply_flg: true,student_id: current_user.student.id)
      @apply_vacancy = apply_vacancy.present? ? true :false
    end
  end

  def favourite_vacancy
    @company_data = Company::Vacancy.find(params[:id])
    @applied_favourite_vacancy = VacancyApplyFavourite.find_by(student_id: current_user.student.id,
                                                                   company_vacancy_id: params[:id])
    if @applied_favourite_vacancy.nil?
      @applied_favourite_vacancy = VacancyApplyFavourite.new(student_id: current_user.student.id, company_id: @company_data.company_id, company_vacancy_id: params[:id],
                                                                favourite_flg: true, favourite_date: Date.today )
      @applied_favourite_vacancy.save
    else
      @applied_favourite_vacancy.toggle!(:favourite_flg)
      @applied_favourite_vacancy.update_attribute(:favourite_date, Date.today)
    end
    
    render json: { status: 'ok', favourite_flag: @applied_favourite_vacancy.favourite_flg }
  end

  # show all admin search article list
  def student_search_article
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    startDate = params[:startDate].blank? ? nil : params[:startDate]
    endDate = params[:endDate].blank? ? nil : params[:endDate]
    @admin_article_result = if startDate.blank? && !endDate.blank?
                              Admin::Article.admin_article_search_by_date_to(endDate, keyword)
                            elsif !startDate.blank? && endDate.blank?
                              Admin::Article.admin_article_search_by_date_from(startDate, keyword)
                            elsif !startDate.blank? && !endDate.blank?
                              Admin::Article.admin_article_search_by_date_between(startDate, endDate, keyword)
                            else
                              Admin::Article.admin_article_all_list(keyword)
                            end
    student_article_list = @admin_article_result.where('admin_articles.show_option = 2 OR admin_articles.show_option = 3')
    @results = Kaminari.paginate_array(student_article_list).page(params[:page]).per(12)
    render 'student/search/search_article'
  end

  def search_student_article_detail
    @admin_article = Admin::Article.find(params[:id])
    if @admin_article.video_link.present?
      @admin_article_video = Kaminari.paginate_array(@admin_article.video_link).page(params[:page]).per(4)
    end
    render 'student/search/search_article_detail'
  end

  def search_event
    partner_id = current_user.partner_id
    user_id = current_user.id
    # set previous path for breadcrumbs
    cookies[:previous_url] = "/student/search_event"
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

    event_organizers_data = if params[:event_organizers].blank?
                      params[:event_organizers] =
                        []
                    else
                      # *format param* params[:event_organizers] ==> [admin,super_partner,partner,company]
                      arr_event_type = []
                      getJsonKey(params[:event_organizers]).each_with_index do |item,index|
                        case index
                        when 0
                          if item === "1"
                            arr_event_type << 3 #admin's event
                          end
                        when 1
                          if item === "1"
                            arr_event_type << 4 #super_partner's event
                          end
                        when 2
                          if item === "1"
                            arr_event_type << 2 #partner's event
                          end
                        when 3
                          if item === "1"
                            arr_event_type << 1 #company's event
                          end
                        end
                      end
                      unless arr_event_type.empty?
                        "events.event_type IN(#{arr_event_type.map(&:to_i).join(', ')})"
                      else
                        []
                      end
                    end        
                          

    area_query = params[:region_id].blank? ? params[:region_id] = [] : "companies.m_region_id = '#{params[:region_id]}'"
 
    remove_past_event_query = params[:removePastEvent].nil? ? " CURRENT_DATE >= events.post_start_date AND CURRENT_DATE <= events.post_end_date" :  "CURRENT_DATE > events.application_deadline "

    @events = Student::Student.event_search_by_association(partner_id,user_id,[event_category_data,start_date_query,end_date_query,keyword_query,area_query,remove_past_event_query,event_organizers_data]).to_a
    favourite_event_current_student
    join_event_current_student
    @events = Kaminari.paginate_array(@events).page(params[:page]).per(12)
    render 'student/search/search_event'
  end

  # show past/finished event lists
  def search_past_event
    @past_events = Student::Student.search_past_event
    favourite_event_current_student
    join_event_current_student
    @past_events = Kaminari.paginate_array(@past_events).page(params[:page]).per(12)
    render 'student/search/search_past_event'
  end

  def search_event_detail
    @event_details = Student::Student.event_details_by_association(params[:id]).take
    
    favo_event = @event_details.apply_favourite_transictions.where(event_favourite: true, student_id: current_user.student.id)

    if @event_details.event_type == 1
      j_event = @event_details.apply_favourite_transictions.where(event_join: true, student_id: current_user.student.id)
      @join_event = j_event.present? ? true : false
    else
      j_event = @event_details.admin_event_participants.where(admin_event_id: @event_details.id, user_id: current_user.id)
      @join_event = j_event.present? ? true : false
    end
    @fav_event = favo_event.present? ? true : false
    @apply_favourite_transictions = ApplyFavouriteTransiction.where(event_join: true)
    @admin_event_joined = Admin::EventParticipant.where(admin_event_id: @event_details.id)
    render 'student/search/search_event_detail'
  end

  def join_event_search_detail
    # @event_details = Student::Student.event_search_by_association(params[:id]).take
    @event_details = Student::Student.join_event_search_by_association(params[:id]).take
    
    favo_event = @event_details.apply_favourite_transictions.where(event_favourite: true, student_id: current_user.student.id)

    if @event_details.event_type == 1
      j_event = @event_details.apply_favourite_transictions.where(event_join: true, student_id: current_user.student.id)
      @join_event = j_event.present? ? true : false
    else
      j_event = @event_details.admin_event_participants.where(admin_event_id: @event_details.id, user_id: current_user.id)
      @join_event = j_event.present? ? true : false
    end
    @fav_event = favo_event.present? ? true : false
    @apply_favourite_transictions = ApplyFavouriteTransiction.where(event_join: true)
    @admin_event_joined = Admin::EventParticipant.where(admin_event_id: @event_details.id)
    render 'student/search/search_event_detail'
  end

  def favourite_event
    @applied_favourite_event = ApplyFavouriteTransiction.find_by(student_id: current_user.student.id,
                                                                 event_id: params[:id])
    if @applied_favourite_event.nil?
      @applied_favourite_event = ApplyFavouriteTransiction.new(student_id: current_user.student.id, company_id: nil, job_id: nil,
                                                               event_id: params[:id], std_com_favourite: false, std_job_favourite: false, com_std_favourite: false, std_job_apply: false,
                                                               event_favourite: true, event_join: false, action_date: Date.today)
    else
      @applied_favourite_event.toggle!(:event_favourite)
      @applied_favourite_event.event_join = @applied_favourite_event.event_join
      @applied_favourite_event.update_attribute(:action_date, Date.today)
    end
    @applied_favourite_event.save
    render json: { status: 'ok', favourite_flag: @applied_favourite_event.event_favourite }
  end

  def join_event
    # get records form CompanyEvents:Table for apply_event_limit
    @company_events = Event.find(params[:id])
    if @company_events.event_type == 1
      # to save event_type = 1 in ApplyFavouriteTransiction tbl
      # get counts form ApplyFavouriteTransiction:Table f counts
      @apply_join_event_count = ApplyFavouriteTransiction.where('event_id = ? AND event_join = ?', params[:id],
                                                              true).count

      # get records form ApplyFavouriteTransiction:Table
      @applied_join_event = ApplyFavouriteTransiction.find_by(student_id: current_user.student.id,
                                                            event_id: params[:id])

      if @applied_join_event.nil?
        @applied_join_event = ApplyFavouriteTransiction.new(student_id: current_user.student.id, company_id: nil, job_id: nil,
                                                            event_id: params[:id], std_com_favourite: false, std_job_favourite: false, com_std_favourite: false, std_job_apply: false,
                                                            event_favourite: false, event_join: true, action_date: Date.today)
        @applied_join_event.save
        render json: { status: 'ok', join_flag: @applied_join_event.event_join }
      elsif @apply_join_event_count < (@company_events.apply_event_limit || 0)
        @applied_join_event.toggle!(:event_join)
        @applied_join_event.event_favourite = @applied_join_event.event_favourite
        @applied_join_event.update_attribute(:action_date, Date.today)
        @applied_join_event.save
        render json: { status: 'ok', join_flag: @applied_join_event.event_join } # if apply limit not exceed com's limit count, all user can join
      elsif @applied_join_event.event_join
        @applied_join_event.toggle!(:event_join)
        @applied_join_event.event_favourite = @applied_join_event.event_favourite
        @applied_join_event.update_attribute(:action_date, Date.today)
        @applied_join_event.save
        render json: { status: 'ok', join_flag: @applied_join_event.event_join } # If limit full and current user is already joined, can enable to unjoin
      end
    else
      # to save event_type = 2,3,4 in EventParticipant tbl
      # get counts form AdminEventParticipant:Table Join counts
      @apply_join_event_count = Admin::EventParticipant.where('admin_event_id = ? ', params[:id]).count

      # get records form EventParticipant:Table
      @applied_join_event = Admin::EventParticipant.find_by(user_id: current_user.id, admin_event_id: params[:id])

      unless @applied_join_event.nil?
        @applied_join_event.destroy
        render json: { status: 'ok', join_flag: false }
      else
        if @apply_join_event_count < (@company_events.apply_event_limit || 0)
          @applied_join_event = Admin::EventParticipant.new(
            user_id: current_user.id,
            company_id: nil,
            partner_user_id: nil,
            partner_id: nil,
            super_partner_user_id: nil,
            super_partner_id: nil,
            company_user_id: nil,
            admin_event_id: params[:id],
            delete_flg: false
          )
          @applied_join_event.save
          admin_event_date_update = Event.find_by(id: @applied_join_event.admin_event_id , delete_flg: false)
          admin_event_date_update.update_columns(updated_at: Time.now )
          render json: { status: 'ok', join_flag: true}
        end
      end
    end
  end

  def apply_vacancy
    @company_data = Company::Vacancy.find(params[:id])
    @applied_vacancy = VacancyApplyFavourite.find_by(student_id: current_user.student.id,
                                                                   company_vacancy_id: params[:id])
    if @applied_vacancy.nil?
      @applied_vacancy = VacancyApplyFavourite.new(student_id: current_user.student.id, company_id: @company_data.company_id, company_vacancy_id: params[:id],
                                                  apply_flg: true, apply_date: Date.today , apply_status: 1)
      @applied_vacancy.save
    else
      @applied_vacancy.update(apply_flg: true, apply_date: Date.today , apply_status: 1)
    end
    
    render json: { status: 'ok', apply_flag: @applied_vacancy.apply_flg }
  end

  def admin_event_search
    cookies[:previous_url] = '/student/admin_event_search'
    keyword = nil 
    event_category_data = params[:category].blank? ? params[:category] = [] : []
    @admin_event_result = Event.admin_event_search_init_list(keyword, [event_category_data])
    join_admin_event_current_user
    @results = @admin_event_result.where('events.event_show_option = 2 OR events.event_show_option = 3')
    @results = Kaminari.paginate_array(@results).page(params[:page]).per(12)
    render "student/search/search_admin_event"
  end

  def admin_event_search_params
    cookies[:previous_url] = '/student/admin_event_search'
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    event_category_data = params[:category].blank? ? params[:category] = [] : "category && ARRAY#{params[:category].map(&:to_i)}"
    date_type = params[:date_type]
    startDate = params[:startDate].blank? ? nil : params[:startDate]
    endDate = params[:endDate].blank? ? nil : params[:endDate]
    if startDate.blank? && !endDate.blank?
        @admin_event_result = Event.admin_event_search_by_only_end_date(date_type, endDate, keyword, [event_category_data])
    elsif(!startDate.blank? && endDate.blank?)
        @admin_event_result = Event.admin_event_search_by_start_date(date_type, startDate, keyword, [event_category_data])
    elsif(!startDate.blank? && !endDate.blank?)
        @admin_event_result = Event.admin_event_search_by_between_two_date(date_type, startDate, endDate, keyword, [event_category_data])   
    else
        @admin_event_result = Event.admin_event_search_init_list(keyword, [event_category_data])
    end 
    join_admin_event_current_user
    @results = @admin_event_result.where('admin_events.event_show_option = 2 OR admin_events.event_show_option = 3')
    @results = Kaminari.paginate_array(@results).page(params[:page]).per(12)
    @apply_join_event_count = Admin::EventParticipant.where('admin_event_id = ? ', params[:id]).count
    render "student/search/search_admin_event"
  end

  def admin_event_detail_search
    @event_details = Event.select('admin_events.*').find(params[:id])
    j_event = @event_details.admin_event_participants.where(user_id: current_user.id)
    @join_event = j_event.present? ? true : false
    render "student/search/search_admin_event_detail"
  end

  def admin_join_event
    # get records form CompanyEvents:Table for apply_event_limit
    @admin_events = Admin::Event.find(params[:id])

    # get counts form EventParticipant:Table f counts
    @apply_join_event_count = Admin::EventParticipant.where('admin_event_id = ? ', params[:id]).count

    # get records form EventParticipant:Table
    @applied_join_event = Admin::EventParticipant.find_by(user_id: current_user.id,
    admin_event_id: params[:id])

    unless @applied_join_event.nil?
      @applied_join_event.destroy
      render json: { status: 'ok', join_flag: false }
    else
      if @apply_join_event_count < (@admin_events.admin_apply_event_limit || 0)
        @applied_join_event = Admin::EventParticipant.new(
          user_id: current_user.id,
          company_id: nil,
          partner_user_id: nil,
          partner_id: nil,
          company_user_id: nil,
          admin_event_id: params[:id],
          delete_flg: false
        )
      @applied_join_event.save
      admin_event_date_update = Admin::Event.find_by(id: @applied_join_event.admin_event_id , delete_flg: false)
      admin_event_date_update.update_columns(updated_at: Time.now )
      render json: { status: 'ok', join_flag: true}
      end
    end
  end
  def search_story_detail
    @story_details = Company::InterviewStory.select("company_interview_stories.id, company_interview_stories.title, 
                      company_interview_stories.review, company_interview_stories.created_at,company_members.department, company_members.position, company_members.company_roles_id
                      ,company_users.first_name, company_users.last_name,company_roles.role_type")
                    .joins("INNER JOIN companies ON companies.id = company_interview_stories.company_id")
                    .joins("INNER JOIN company_members ON company_members.user_id = company_interview_stories.user_id ")
                    .joins("INNER JOIN company_roles ON company_roles.id = company_members.company_roles_id")
                    .joins("INNER JOIN company_users ON company_users.id = company_members.user_id")
                    .where("company_interview_stories.id = #{params[:id]}").take
    render 'student/search/search_story_detail'
  end

  private

  def set_company_vacancy
    @company_vacancy = Company::Vacancy.find(params[:id])
  end

  def favourite_company_current_student
    @student_favourite_arr = []
    student_favourite = current_user.student.apply_favourite_transictions.where(std_com_favourite: true)
    @student_favourite_arr = student_favourite.map { |data| data.company_id } unless @student_favourite.present?
  end

  def favourite_vacancy_current_student
    @vacancy_favourite_arr = []
    vacancy_favourite = current_user.student.vacancy_apply_favourites.where(favourite_flg: true)
    @vacancy_favourite_arr = vacancy_favourite.map { |data| data.company_vacancy_id } unless @vacancy_favourite.present?
  end

  def apply_vacancy_current_student
    @vacancy_applu_arr = []
    vacancy_apply = current_user.student.vacancy_apply_favourites.where(apply_flg: true)
    @vacancy_apply_arr = vacancy_apply.map { |data| data.company_vacancy_id } unless @vacancy_apply.present?
  end

  def favourite_event_current_student
    @event_favourite_arr = []
    event_favourite = current_user.student.apply_favourite_transictions.where(event_favourite: true)
    @event_favourite_arr = event_favourite.map { |data| data.event_id } unless @event_favourite.present?
  end

  def join_event_current_student
    @join_event_arr = []
    join_event = current_user.student.apply_favourite_transictions.where(event_join: true)
    join_admin_event = current_user.admin_event_participants
    @apply_favourite_transictions = ApplyFavouriteTransiction.where(event_join: true)
    @admin_event_participants = Admin::EventParticipant.all
    @join_event_arr = join_event.map { |data| data.event_id } unless @join_event.present?
    join_admin_event_arr = join_admin_event.map { |data| data.admin_event_id } unless @join_event.present?
    @join_event_arr.concat(join_admin_event_arr)
  end

  def similar_companies
    @similar_companies = Company::Company.select('companies.*,m_industries.industry_name,m_regions.region_name').joins(:m_industries,:m_regions).where(m_industry_id: Company::Company.where(id:params[:id]).first.m_industry_id).limit(4) 
  end

  def join_admin_event_current_user
    @join_event_arr = []
    join_event = current_user.admin_event_participants.where.not(user_id: nil)
    @join_event_arr = join_event.map{|data| data.admin_event_id} unless @join_event.present?
  end

end
