class Communication::CommunicationsController < ApplicationController
  before_action :authenticate_company_user!, if: :company_user_signed_in?
  before_action :authenticate_user!, if: :user_signed_in?
  before_action :set_communication_communication, only: %i[ show edit update destroy conversation_forum scout_mail_accept scout_mail_reject ]
  include CommonHelper
  include Student::AssessmentsHelper
  # GET /communication/communications or /communication/communications.json
  def index
    # mail_type = 1111 => scotted , 2222 => direct message
    if params[:mail_type] == '1111' || params[:mail_type] == nil
      if check_user_type == LogoutHistory.active_types["company"].to_i 
        @conversation_list = (Communication::Communication.new.get_all_communication(0,current_user_data.id,current_company.id, 1 , check_user_type)).sort_by(&:created_at).reverse
      else
        cookies[:previous_url] = "communication/communications?mail_type=1111"
        @conversation_list = (Communication::Communication.new.get_all_communication(current_user_data.id,0,0,1, check_user_type)).sort_by(&:created_at).reverse
      end
    else
      if check_user_type == LogoutHistory.active_types["company"].to_i 
        @conversation_list = (Communication::Communication.new.get_all_communication(0,current_user_data.id,current_company.id, 2 , check_user_type)).sort_by(&:created_at).reverse
      else
        cookies[:previous_url] = "communication/communications?mail_type=2222"
        @conversation_list = (Communication::Communication.new.get_all_communication(current_user_data.id,0,0,2, check_user_type)).sort_by(&:created_at).reverse
      end
    end
    @conversation_list = Kaminari.paginate_array(@conversation_list).page(params[:page]).per(12)
    new_communication_array
  end

  # GET /communication/communications/1 or /communication/communications/1.json
  def show
    # start::for scout communication modal
    studentInfo = Student::Student.find_by(:id => params[:student_id])
    set_student_data(studentInfo)
    # end::for scout communication modal

    respond_to do |format|
      format.js {render 'communication/communications/show_modal'}
    end
  end

  def get_user_id_by_company(company_id)
    Company::CompanyMember.find_by(company_id: company_id , company_roles_id: 1, join_flag: true).user_id
  end

  # GET /communication/communications/new
  def new
    @communication_communication = Communication::Communication.new
    if check_user_type == LogoutHistory.active_types["company"].to_i 
      # start::for scout communication modal
      studentInfo = Student::Student.find_by(:id => params[:id])
      set_student_data(studentInfo)
      # end::for scout communication modal

      @receiver_id = studentInfo.user_id
      @receiverMail = User.find(@receiver_id).email
      @user_id = studentInfo.user_id
      @company_user_id = current_user_data.id
      @company_id = Company::CompanyMember.find_by(user_id: @company_user_id, join_flag: true).company_id
    else
      @user_id =  current_user_data.id
      ## Student [name] => Company_member [name]
      if params[:name] === Communication::Communication.categories["member"]
        @receiver_id =  params[:forum_id]
        @company_user_id = params[:forum_id]
        @company_id = Company::CompanyMember.find_by(user_id: @company_user_id, join_flag: true).company_id
      else
        ## Student [name] <=> Company [name]
        @receiver_id = get_user_id_by_company(params[:id])
        @company_user_id = get_user_id_by_company(params[:id])
        @company_id = Company::CompanyMember.find_by(user_id: @company_user_id, join_flag: true).company_id
      end
      @receiverMail = CompanyUser.find(@receiver_id).email
    end
    #@receiverMail = User.find(@receiver_id).email
    @category_name = params[:name]
    respond_to do |format|
      format.js {render 'communication/communications/show_modal'}
      format.json { render json: @communication_communication.errors}
    end
  end
  
  # GET /communication/template_change
  def template_change
    @mail_template = Communication::MailTemplateRegistration.where(:id=> params[:mail_template_id]).take
    render json: { subject: @mail_template.subject, content: @mail_template.content }
  end

  #communicate with multiple users
  def new_communicate_list
    @communication_communication = Communication::Communication.new
    params[:id] = 
    receiver_ids = params[:receiver_ids].delete_if {|x| x <= "0" }
    if check_user_type == LogoutHistory.active_types["company"].to_i 
      studentInfo = Student::Student.where(:id => receiver_ids)
      array_std_ids = Array.new
      array_std_email = Array.new
      studentInfo.each do |std|
        array_std_ids << std.user_id
        array_std_email << User.find(std.user_id).email
      end
      @receiver_id = array_std_ids.join(', ')
      @receiverMail = array_std_email.join(', ')
      params[:id] = current_company.id
    else
      ## Student [name] => Company_member [name]
      if params[:name] === Communication::Communication.categories["member"]
        @receiver_id =  params[:forum_id]
      else
        ## Student [name] <=> Company [name]
        @receiver_id = get_user_id_by_company(params[:id])
      end
      @receiverMail = CompanyUser.find(@receiver_id).email
    end
    #@receiverMail = User.find(@receiver_id).email
    @category_name = params[:name]
    @user_id = array_std_ids.join(', ')
    respond_to do |format|
     format.js {render 'communication/communications/show_multi_modal'}
     format.json { render json: @communication_communication.errors}
   end
  end

  # GET /communication/communications/1/edit
  def edit
  end

  # POST /communication/communications or /communication/communications.json
  # mail_type --> 1 = scoted type & --> 2 =  direct message
  def create    
    @communication_communication = Communication::Communication.new(communication_communication_params)
    @communication_communication.mail_type = params[:communication_communication][:category] === "Member" ? 2 : 1 
    @communication_communication.company_id = params[:communication_communication][:company_id]
    # sent_type [ 1=> company sent , 2=> student sent ]
    @communication_communication.sent_type = check_user_type
    @communication_communication.user_id =  params[:communication_communication][:user_id]
    @communication_communication.company_user_id =  params[:communication_communication][:company_user_id]
    # scout_status [ 1=> Not Accept ]
    @communication_communication.scout_status = 1 if @communication_communication.mail_type == 1
    @communication_communication.scout_date = Time.now if @communication_communication.mail_type == 1
    @communication_communication.vacancy_id = params[:communication_communication][:vacancy_id]
    
    respond_to do |format|
      if @communication_communication.save

        #begin::save communication_detail table
        @communication_details = Communication::CommunicationDetail.new
        @communication_details.communication_id = @communication_communication.id
        @communication_details.content = params[:communication_communication][:content]
        @communication_details.sent_type = @communication_communication.sent_type
        @communication_details.user_id = @communication_communication.user_id
        @communication_details.company_user_id = @communication_communication.company_user_id
        @communication_details.sender_id = params[:communication_communication][:sender_id]
        @communication_details.receiver_id = params[:communication_communication][:receiver_id]
        @communication_details.save
        #end::save communication_detail table

        #start::register mail template if checked
        if params[:communication_communication][:mail_template_id] == ""
          if params[:communication_communication][:save_template_chk_box] == "1"
            today_mail_template_count = Communication::MailTemplateRegistration.where(company_id: current_company.id, created_at: Date.today.beginning_of_day..Time.zone.now).count
            mail_register = Communication::MailTemplateRegistration.new
            mail_register.company_id = current_company.id
            mail_register.subject = params[:communication_communication][:title]
            mail_register.content = params[:communication_communication][:content]
            mail_register.template_name = Date.today.strftime('%Y年%m月%d日').to_s + "##{today_mail_template_count+1}_" + mail_register.subject
            mail_register.save
          end
        else
          if params[:communication_communication][:save_template_chk_box] == "1"
            mail_register = Communication::MailTemplateRegistration.find(params[:communication_communication][:mail_template_id])
            mail_register.update(subject: params[:communication_communication][:title],content: params[:communication_communication][:content])
          end
        end
        #end::register mail template if checked

        #get receiver_id
        receiver_id = 0
        if  check_user_type == LogoutHistory.active_types["user"].to_i
          receiver_id = @communication_details.company_user_id
        else
          receiver_id = @communication_details.user_id
        end
                
        # save into notification table
        notifications = Communication::Notification.new(:record_type=>"message_sent", :record_id=>@communication_communication.id,:sender_id=>current_user_data.id,:receiver_id => receiver_id,:sent_type=> check_user_type.to_i)
        notifications.save
        #get receiver name and email for mailer
        receiver = get_receiver_info(@communication_communication.company_user_id,@communication_communication.user_id,@communication_communication.company_id,@communication_communication.mail_type,check_user_type.to_i)
        
        if check_user_type == LogoutHistory.active_types["user"].to_i
          # get notificatin count by communication_id and receiver_id
          notiCount = Communication::Notification.where("receiver_id = ? AND sent_type = ?", receiver_id,LogoutHistory.active_types["user"].to_i ).count
          #get mail_setting from company table
          # mail_setting = Company::Company.find_by(:id => params[:communication_communication][:company_id]).mail_setting
          # unless mail_setting == 0 
            # if mail_setting == 1
              Communication::CommunicationMailer.with(receiver_name: receiver["name"], receiver_email: receiver["email"]).communication_email.deliver_now
            # elsif notiCount >= mail_setting && notiCount % mail_setting == 0
              # Communication::CommunicationMailer.with(receiver_name: receiver["name"], receiver_email: receiver["email"]).communication_email.deliver_now
              # end 
          # end
          
          ##communication_communication category = "Company,Event,Vacancy --> socted message / ''-> direct message "
          
          # page render by sent message pages
          if params[:communication_communication][:category] == Communication::Communication.categories["company"]
            format.html { redirect_to student_company_home_path(params[:communication_communication][:forum_id])}
          elsif  params[:communication_communication][:category] == Communication::Communication.categories["event"]
            format.html { redirect_to student_event_details_path(params[:communication_communication][:forum_id])}
          elsif params[:communication_communication][:category] == Communication::Communication.categories["vacancy"]
            format.html { redirect_to student_vacancy_details_path(params[:communication_communication][:forum_id])}
          elsif params[:communication_communication][:category] == Communication::Communication.categories["student"]
            format.html { redirect_to company_student_details_path(params[:communication_communication][:forum_id])}
          else #communication_communication category ==> "member"
            format.html {redirect_to company_page_members_path(params[:communication_communication][:company_id])}
          end
        else
          Communication::CommunicationMailer.with(receiver_name: receiver["name"], receiver_email: receiver["email"]).communication_email.deliver_now
          if cookies[:previous_url] == "/company/student_details"
            format.html { redirect_to company_student_details_path(:id=> receiver_id)}
          else
            format.html { redirect_to company_students_search_path(params[:communication_communication][:forum_id])}
          end        
        end        
      else
        format.html { render :new }
        format.json { render json: @communication_communication.errors}
      end
    end
  end

  # POST /communication/communications or /communication/communications.json
  # mail_type --> 1 = scoted type
  def create_with_multiple_users    
    # start::loop
    params[:user_id].split(',').map(&:to_i).each do |receiver_id|
      @communication_communication = Communication::Communication.new
      @communication_communication.mail_type = 1 
      @communication_communication.company_id = params[:company_id]
      # sent_type [ 1=> company sent , 2=> student sent ]
      @communication_communication.sent_type = check_user_type
      @communication_communication.title = params[:title]
      @communication_communication.content = params[:content]
      @communication_communication.sender_id = params[:sender_id]
      @communication_communication.receiver_id = receiver_id
      @communication_communication.user_id = receiver_id
      @communication_communication.company_user_id = params[:company_user_id]
      @communication_communication.category = params[:category]
      # scout_status [ 1=> Not Accept ]
      @communication_communication.scout_status = 1 if @communication_communication.mail_type == 1
      @communication_communication.scout_date = Time.now if @communication_communication.mail_type == 1
      if @communication_communication.save

        #begin::save communication_detail table
        @communication_details = Communication::CommunicationDetail.new
        @communication_details.communication_id = @communication_communication.id
        @communication_details.content = params[:content]
        @communication_details.sent_type = @communication_communication.sent_type
        @communication_details.user_id = @communication_communication.user_id
        @communication_details.company_user_id = @communication_communication.company_user_id
        @communication_details.sender_id = @communication_communication.sender_id
        @communication_details.receiver_id = @communication_communication.receiver_id
        @communication_details.save
        #end::save communication_detail table

        #get receiver_id
        receiver_id = 0
        if  check_user_type == LogoutHistory.active_types["user"].to_i
          receiver_id = @communication_details.company_user_id
        else
          receiver_id = @communication_details.user_id
        end

        # save into notification table
        notifications = Communication::Notification.new(:record_type=>"message_sent", :record_id=>@communication_communication.id,:sender_id=>current_user_data.id,:receiver_id => receiver_id,:sent_type=> check_user_type.to_i)
        notifications.save
        #get receiver name and email for mailer
        receiver = get_receiver_info(@communication_communication.company_user_id,@communication_communication.user_id,@communication_communication.company_id,@communication_communication.mail_type,check_user_type.to_i)

        if check_user_type == LogoutHistory.active_types["user"].to_i
          # get notificatin count by communication_id and receiver_id
          notiCount = Communication::Notification.where("receiver_id = ? AND sent_type = ?", receiver_id,LogoutHistory.active_types["user"].to_i ).count
          #get mail_setting from company table
          # mail_setting = Company::Company.find_by(:id => params[:communication_communication][:company_id]).mail_setting
          # unless mail_setting == 0
            # if mail_setting == 1
              Communication::CommunicationMailer.with(receiver_name: receiver["name"], receiver_email: receiver["email"]).communication_email.deliver_now
            # elsif notiCount >= mail_setting && notiCount % mail_setting == 0
              # Communication::CommunicationMailer.with(receiver_name: receiver["name"], receiver_email: receiver["email"]).communication_email.deliver_now
              # end 
          # end
          
          ##communication_communication category = "Company,Event,Vacancy --> socted message / ''-> direct message "
          # page render by sent message pages
          if params[:communication_communication][:category] == Communication::Communication.categories["company"]
          format.html { redirect_to student_company_home_path(params[:communication_communication][:forum_id])}
          elsif  params[:communication_communication][:category] == Communication::Communication.categories["event"]
            format.html { redirect_to student_event_details_path(params[:communication_communication][:forum_id])}
          elsif params[:communication_communication][:category] == Communication::Communication.categories["vacancy"]
            format.html { redirect_to student_vacancy_details_path(params[:communication_communication][:forum_id])}
          elsif params[:communication_communication][:category] == Communication::Communication.categories["student"]
            format.html { redirect_to company_student_details_path(params[:communication_communication][:forum_id])}
          else #communication_communication category ==> "member"
            format.html {redirect_to company_page_members_path(params[:communication_communication][:company_id])}
          end
        else
          Communication::CommunicationMailer.with(receiver_name: receiver["name"], receiver_email: receiver["email"]).communication_email.deliver_now 
        end        
      else
        format.html { render :new }
        format.json { render json: @communication_communication.errors}
      end

    end
    # end::loop

    if params[:category]  === "Company"
      redirect_to company_favourite_student_list_path
    else
      redirect_to company_applied_student_list_path
    end
  end

  # Scout Mail Accept
  def scout_mail_accept
    # [ 1 -> not accept, 2 -> accept, 3 -> denied ]
    @communication_communication.update_column(:scout_status, 2)
    # insert into application_status_transaction & application_status_transaction_detail
    create_application_status(@communication_communication.user_id,@communication_communication.company_user_id,@communication_communication.id,@communication_communication.vacancy_id,2,1)
    # apply vacancy on scout mail accept
    @applied_vacancy = VacancyApplyFavourite.find_by(student_id: current_user.student.id,
                                                    company_vacancy_id: @communication_communication.vacancy_id)
    if @applied_vacancy.nil?
      @applied_vacancy = VacancyApplyFavourite.new(student_id: current_user.student.id, company_id: @communication_communication.company_id, company_vacancy_id: @communication_communication.vacancy_id,
                                                                 apply_flg: true, apply_date: Date.today , apply_status: 2, apply_status_date: Date.today)
      @applied_vacancy.save
    else
      @applied_vacancy.update(apply_flg: true, apply_date: Date.today , apply_status: 2, apply_status_date: Date.today)
    end
   
    # page render by sent message pages
    page_render_on_scout_submit
  end

  # Scout Mail Reject  
  def scout_mail_reject
    # [ 1 -> not accept, 2 -> accept, 3 -> denied ]
    @communication_communication.update_column(:scout_status, 3)
    # page render by sent message pages
    page_render_on_scout_submit
  end

  # PATCH/PUT /communication/communications/1 or /communication/communications/1.json
  def update
    respond_to do |format|
      if @communication_communication.update(communication_communication_params)
        format.html { redirect_to @communication_communication, notice: "Communication was successfully updated." }
        format.json { render :show, status: :ok, location: @communication_communication }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @communication_communication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /communication/communications/1 or /communication/communications/1.json
  def destroy
    @communication_communication.destroy
    respond_to do |format|
      format.html { redirect_to communication_communications_url, notice: "Communication was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def conversation_forum
    @conversation_detail_list = Communication::CommunicationDetail.where(:communication_id => params[:id]).order(:created_at).to_a
    @user_id = 0
    sent_type = 0
    @email = ""

    if check_user_type == LogoutHistory.active_types["user"].to_i
       @user_id = current_user.id
       @email = current_user.email
      # user read message sent by computer
      sent_type = 1
    else
       @user_id = current_company_user.id
       @email = current_company_user.email
      # company read message sent by user
      sent_type = 2
    end
    readNotification = Communication::Notification.where("record_id = ? AND receiver_id = ? AND sent_type = ? ",params[:id], @user_id,sent_type ).destroy_all
    if check_user_type == LogoutHistory.active_types["user"].to_i
      if cookies[:previous_url] == "communication/communications?mail_type=2222"
        render "communication/communications/list/conversation_form"
      else
        @company_vacancy_list = Company::Vacancy.left_outer_join_application_status_transactions(current_user.student.id).select('company_vacancies.*,m_industries.industry_name,m_occupations.occupation_name, application_status_transactions.status')
                                .joins(:m_industries,:m_occupations).where(id: @communication_communication.vacancy_id).take
        @company_img = Company::Company.select("companies.*").where(id: @company_vacancy_list.company_id).take
        @welfare_list = if @company_vacancy_list.welfare_list_data.present?
                                  welfare_list = @company_vacancy_list.welfare_list_data.select { |item| nil != item}
                                  welfare_data_index =  welfare_list.each_index.select { |i| welfare_list[i]== 1 }.map!{|element| element.is_a?(Integer) ? element + 1 : element}
                                  if welfare_data_index.any?
                                    #MWelfareDetail.where("id IN (#{welfare_data_index.join(',')})").map { |wf| [wf.welfare_type]}.join(', ')
                                    MWelfareDetail.where("id IN (#{welfare_data_index.join(',')})")
                                  end
                                end
        respond_to do |format|
          format.js {render 'communication/communications/show_modal'}
          # page render by sent message pages
          if cookies[:previous_url] == "/student/scouted_result"
            format.html { redirect_to student_scouted_result_path }
          elsif cookies[:previous_url] == "/student/students"
            format.html { redirect_to student_students_path }
          elsif cookies[:previous_url] == "communication/communications?mail_type=1111"
            format.html { redirect_to communication_communications_path(mail_type: "1111") }
          end
        end
      end
    else
      render "communication/communications/list/conversation_form"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_communication_communication
      @communication_communication = Communication::Communication.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def communication_communication_params
      params.require(:communication_communication).permit(:title, :category,:sender_id, :receiver_id, :content,:company_user_id,:user_id,:scout_status,:scout_date, :vacancy_id, :save_template_chk_box)
      
    end

    def set_student_data(studentInfo)
      # start::for scout communication modal
      @student_nick_name = studentInfo.nick_name
      @student_commmitment_commitment = studentInfo.commitment
      @student_image = studentInfo.image
      @student_gender = studentInfo.gender
      @student_cover_photo = studentInfo.cover_photo
      @student_address = studentInfo.current_address
      @student_preferred_working_area = studentInfo.preferred_working_area
      # For commitment chart
      commitment_ability_chart(studentInfo)
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
      # end::for scout communication modal
    end
end
