class CompanyPageController < ApplicationController
  before_action :authenticate_user!, :authorize_user!
  before_action :set_company, only: %i[ home about_us recruitment stories activity vacancies events members story_detail vacancy_detail event_detail activity_detail] 
  layout 'layouts/template/company_page'
  
  def home
    cookies[:previous_url] = "/home"
    @company_interview_story_hightlight = Company::InterviewStory.where(:company_id => params[:id]).last(3).reverse
    @company_vacancies = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name').joins(:m_industries,:m_occupations).where("company_id= ?", params[:id]).order(created_at: :desc).last(2)
    @company_events_hightlight = Company::Company.new.get_event_entry_list(params[:id]).last(2).reverse
    @company_company_members = Company::CompanyMember.left_outer_joins(:company_roles).where("company_members.company_id = '#{params[:id]}' AND company_members.user_id is NOT NULL").order(id: :asc).limit(4)
    @company_activities = Company::Activity.where(:company_id => params[:id]).order("created_at desc")
    @company_commitment_profile =  Company::Company.select('companies.*').where(id: params[:id]).take
    @company_activities = Company::Activity.where(:company_id => params[:id]).last(3).reverse
    if current_user
      favo_company = @company_details.apply_favourite_transictions.where(std_com_favourite: true,
                                                                        student_id: current_user.student.id)
      @fav_company = favo_company.present? ? true : false
    end
  end

  def about_us
    @company_company_members = Company::CompanyMember.left_outer_joins(:company_roles).where("company_members.company_id = '#{params[:id]}' AND company_members.user_id is NOT NULL").order(id: :asc).limit(4)
    @company_commitment_profile =  Company::Company.select('companies.*').where(id: params[:id]).take
  end

  def recruitment
    @company_commitment_profile =  Company::Company.select('companies.*').where(id: params[:id]).take
    @company_vacancies = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name').joins(:m_industries,:m_occupations).where("company_id= ?", params[:id]).order(created_at: :desc).last(2)
  end
  
  def stories
    @company_interview_story_hightlight = Company::InterviewStory.where(:company_id => params[:id]).last(3).reverse
    @company_interview_story_lists = Company::InterviewStory.where(:company_id => params[:id]).reverse
    @company_interview_story_lists = Kaminari.paginate_array(@company_interview_story_lists).page(params[:page]).per(10)
    @company_vacancies = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name').joins(:m_industries,:m_occupations).where("company_id= ?", params[:id]).order(created_at: :desc).last(2)
  end

  def activity
    @company_activity_lists = Company::Activity.where(:company_id => params[:id]).reverse
    @company_activity_lists = Kaminari.paginate_array(@company_activity_lists).page(params[:page]).per(10)
  end

  def vacancies
    @company_vacancies = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name').joins(:m_industries,:m_occupations).where("company_id= ?", params[:id]).reverse
    @company_vacancies = Kaminari.paginate_array(@company_vacancies).page(params[:page]).per(10)
  end
  
  def events
    @company_events_hightlight = Company::Company.new.get_event_entry_list(params[:id]).last(2).reverse
    @company_events = Company::Company.new.get_event_entry_list(params[:id]).reverse
    @company_events = Kaminari.paginate_array(@company_events).page(params[:page]).per(12)
  end
  
  def members
    cookies[:previous_url] = "/members"
    @company_commitment_profile =  Company::Company.select('companies.*').where(id: params[:id]).take
    @company_company_members = Company::CompanyMember.select('company_members.*,company_roles.role_type').left_outer_joins(:company_roles).where("company_members.company_id = '#{params[:id]}' AND company_members.user_id is NOT NULL")
    @company_company_members = Kaminari.paginate_array(@company_company_members).page(params[:page]).per(40)
    @company_vacancies = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name').joins(:m_industries,:m_occupations).where("company_id= ?", params[:id]).order(created_at: :desc).last(2)
  end

  def activity_detail 
    @company_activity = Company::Activity.select("company_activities.*").joins("INNER JOIN companies ON companies.id = company_activities.company_id").where("company_activities.id = #{params[:activity_id]}").take 
    @company_activities = Company::Activity.where(:company_id => params[:id]).last(3).reverse
    render 'company_page/activity_detail'
  end

  def story_detail 
     @story_details = Company::InterviewStory.select("company_interview_stories.id, company_interview_stories.title, 
                                              company_interview_stories.review, company_interview_stories.created_at,company_members.department, company_members.position, company_members.company_roles_id
                                              ,company_users.first_name, company_users.last_name,company_roles.role_type")
                                            .joins("INNER JOIN companies ON companies.id = company_interview_stories.company_id")
                                            .joins("INNER JOIN company_members ON company_members.user_id = company_interview_stories.user_id ")
                                            .joins("INNER JOIN company_roles ON company_roles.id = company_members.company_roles_id")
                                            .joins("INNER JOIN company_users ON company_users.id = company_members.user_id")
                                            .where("company_interview_stories.id = #{params[:story_id]}").take 
    @company_interview_story_hightlight = Company::InterviewStory.where(:company_id => params[:id]).last(3).reverse
    render 'company_page/story_detail'
  end

  def vacancy_detail
    @company_vacancy_list = Company::Vacancy.left_outer_join_application_status_transactions(current_user.student.id).select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name,application_status_transactions.status')
                                        .joins(:m_industries,:m_occupations).where(id: params[:vacancy_id]).take
                                    
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

      @company_vacancies = Company::Vacancy.select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name').joins(:m_industries,:m_occupations).where("company_id= ?", params[:id]).last(2).reverse
  end
 

  def event_detail
    partner_id = current_user.partner_id
    user_id = current_user.id
    @event_details = Event.select("events.*,
                                  CASE WHEN Current_date <= events.application_deadline THEN 
                                  CASE WHEN (CURRENT_DATE BETWEEN events.application_start_date AND events.application_deadline) AND (apply.join_count >= events.apply_event_limit) THEN '3'
                                  ELSE 
                                      CASE WHEN CURRENT_DATE >= events.post_start_date AND CURRENT_DATE < events.application_start_date  THEN '1'
                                      ELSE '2'
                                      END	
                                  END
                                  ELSE '4' END AS status")
                                  .joins("LEFT JOIN (Select event_id,count(event_id) AS join_count From apply_favourite_transictions where event_join = 'true' group by event_id order by event_id) as apply  on apply.event_id = events.id")
                                  .where("events.delete_flg = false AND events.id= #{params[:event_id]}
                                          AND CURRENT_DATE BETWEEN events.post_start_date AND events.post_end_date 
                                          AND events.event_show_option IN(#{Event.event_show_options[:student]},#{Event.event_show_options[:all_user]})").take

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
  end
 

  private
  def set_company
    @company_details = Company::Company.select('companies.*,m_industries.industry_name').joins(:m_industries).find(params[:id])

    student_favourite = current_user.student.apply_favourite_transictions.where(std_com_favourite: true)
    @student_favourite_arr = student_favourite.map { |data| data.company_id } unless @student_favourite.present?
  end

   
end
