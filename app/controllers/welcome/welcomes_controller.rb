class Welcome::WelcomesController < ApplicationController
  include Accessible
  skip_before_action :check_path, only: %i[privacy_index contact_index destroy term_condition_index contact_create]
  
  def index
    @usertype = '2'
    @user = User.new
  end

  def company_index
    @usertype = '1'
  end

  def student_index
    @usertype = '2'
    delete_flag_query = 'delete_flg = false'
    @welcome_event_list = Company::Event.all.where("delete_flg = 'false'").order('created_at DESC').limit(5)
  end

  def contact_index
    @usertype = params[:user_type].nil? ? 0 : params[:user_type].to_i
    @usertype = check_user_type if user_signed_in?
    @contact = Contact.new
    render 'welcome/contact_privacy/contact_index'
  end

  def contact_create
    @contact = Contact.new(contact_params)
    # insert basic info fields if signed in
    if user_signed_in?
      @contact.classification = t("welcome.privacy policy.top_page_link.text1")
      @contact.name = current_user.student.nick_name
      @contact.company_name = current_user.student.school_name
      @contact.email = current_user.email
      @contact.contact = current_user.student.phone_no
    elsif company_user_signed_in?
      @contact.classification = t("welcome.privacy policy.top_page_link.text2")
      @contact.name = current_company.company_name
      @contact.company_name = current_company.company_name 
      @contact.email = current_company.contact_email
      @contact.contact = current_company.contact
    end
    respond_to do |format|
      if @contact.save
        Welcome::ContactUsMailer.with(contact: @contact).contact_email.deliver_now
        format.html do
          redirect_to welcome_contact_path(user_type: params[:user_type]),
                      notice: 'この度はお問い合わせいただき誠にありがとうございます。弊社にてお送りいただきました内容を確認のうえ、折り返しご連絡させていただきます。'
        end
      else
        @usertype = params[:user_type].to_i
        format.html { render 'welcome/contact_privacy/contact_index' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def privacy_index
    @usertype = params[:user_type].nil? ? 0 : params[:user_type].to_i
    @usertype = check_user_type if user_signed_in?
    render 'welcome/contact_privacy/privacy_index'
  end

  def term_condition_index
    @user_type = 0
    @user_type = check_user_type if user_signed_in?
    render 'welcome/contact_privacy/term_condition_index'
  end

  def event_index
    @user_type = 0
    delete_flag_query = 'delete_flg = false'
    @welcome_event_list = Company::Event.all.where("delete_flg = 'false'").order('created_at DESC')
    @welcome_event_list = Kaminari.paginate_array(@welcome_event_list).page(params[:page]).per(5)
    render 'welcome/contact_privacy/event_index'
  end

  def registration_complete; end

  def company_login
    Users::SessionsController.set_userType('1')
    redirect_to(user_session_path)
  end

  def company_register
    Users::RegistrationsController.set_userType('1')
    # redirect_to(new_company_user_registration_path(confirm_member_token: params[:confirm_member_token], email: params[:email]))
    company_member = Company::CompanyMember.find_by(confirmation_token: params[:confirm_member_token])
    company_user = CompanyUser.find_by(email: company_member.user_email)

    if company_member.present?
      if company_user.present?
        redirect_to company_genuine_password_path(confirmation_token: company_user.confirmation_token)
      else
        c_user = CompanyUser.new
        c_user.confirmation_token = Devise.token_generator.digest(CompanyUser, :confirmation_token, CompanyUser.last.confirmation_token)
        c_user.email = company_member.user_email
        c_user.confirmed_at = Time.zone.now
        c_user.save(validate: false)
        company_member.update(user_id: c_user.id)	

        redirect_to company_genuine_password_path(confirmation_token: c_user.confirmation_token)
      end
    end
  end

  def student_login
    Users::SessionsController.set_userType('2')
    redirect_to(user_session_path)
  end

  def student_register
    Users::RegistrationsController.set_userType('2')
    redirect_to(new_user_registration_path(confirm_member_token: params[:confirm_member_token], email: params[:email]))
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :company_name, :content_inquiry, :classification, :contact)
  end
end

