class Company::CompanyMembersController < ApplicationController
  before_action :authenticate_company_user!, except: %i[ company_member_confirmation company_member_accept company_member_reject ]
  # before_action :authorize_company!, except: %i[ company_member_confirmation company_member_accept company_member_reject]
  before_action :set_company_company_member, only: %i[ edit update destroy ]
  load_and_authorize_resource param_method: :company_company_member_params, except: [:company_member_confirmation, :company_member_accept, :company_member_reject]
  
  # GET /company/company_members or /company/company_members.json
  def index
    company_members = Company::CompanyMember.select('company_members.*,company_users.first_name, company_users.last_name,company_roles.role_type').left_outer_joins(:company_users).left_outer_joins(:company_roles).where("company_members.company_id = '#{current_company.id}'").order("company_roles.id")
    @company_company_members = Kaminari.paginate_array(company_members).page(params[:page]).per(10)
  end

  # GET /company/company_members/1 or /company/company_members/1.json
  def show
    @company_company_member = Company::CompanyMember.select('company_members.*,company_roles.role_type').left_outer_joins(:company_roles).find(params[:id])
  end

  # GET /company/company_members/new
  def new
    @company_company_member = Company::CompanyMember.new
  end

  # GET /company/company_members/1/edit
  def edit
  end

  # POST /company/company_members or /company/company_members.json
  # ==================================================
  #              Company Member Create
  # ==================================================
  def create
    @company_company_member = Company::CompanyMember.new(company_company_member_params)
    @company_company_member.created_userid = current_company_user.id
    @company_company_member.company_id = @user_data.id
    company_user = CompanyUser.find_by_email(@company_company_member.user_email)
    unless company_user.nil?
      @company_company_member.user_id = company_user.id
    end

    respond_to do |format|
      if @company_company_member.save
        save_img
        JoinMember::JoinMemberMailer.with(company_member_mails: @company_company_member, company_name: @user_data.company_name).member_mails.deliver_now
        format.html { redirect_to company_company_members_path, notice: "Company member was successfully created." }
        format.json { render :new, status: :created, location: @company_company_member }
        flash[:success] = [t('common.create_success'), t('company_member.title.member')]
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company_company_member.errors, status: :unprocessable_entity }
        flash[:error] = [t('common.create_error'), t('company_member.title.member')]
      end
    end 
  end

  # PATCH/PUT /company/company_members/1 or /company/company_members/1.json
  def update
    @company_company_member.updated_userid = current_company_user.id
    # To delete upload image
    if params[:company_company_member][:imageFlag] == "true"
      @company_company_member.image.purge
    end
    save_img
    respond_to do |format|
      if @company_company_member.update(company_company_member_params)
        format.html { redirect_to company_company_members_path}
        format.json { render :show, status: :ok, location: @company_company_member }
        flash[:success] = [t('common.update_success'), t('company_member.title.member')]
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company_company_member.errors, status: :unprocessable_entity }
        flash[:error] = [t('common.update_error'), t('company_member.title.member')]
      end
    end
  end

  def get_company_name(company_id)
    @company_name = Company::Company.find_by_id(company_id).company_name
  end

  # DELETE /company/company_members/1 or /company/company_members/1.json
  # ========================================================
  #     Company Member Delete and Company User Delete
  # ========================================================
  def destroy
    company_user = CompanyUser.find_by_email(@company_company_member.user_email)
    @company_company_member.destroy
    if company_user.present?
      company_user.destroy
    end
    respond_to do |format|
      format.html { redirect_to company_company_members_url}
      format.json { head :no_content }
    end
  end

  #======================================
  #    Company Member Comfirm With Email
  #======================================
  def company_member_confirmation
    @company_member = Company::CompanyMember.find_by(confirmation_token: params[:confirmation_token])   
    unless @company_member.present?
      redirect_to root_path and return
    else
      company_user = CompanyUser.find_by(email: @company_member.user_email)
      if @company_member.join_flag == true
        if company_user.present?
          if company_user.first_name.blank? && company_user.last_name.blank?
            redirect_to welcome_company_register_path(confirm_member_token: @company_member.confirmation_token, email: @company_member.user_email) and return
          else
            redirect_to new_company_user_session_path(email: @company_member.user_email) and return
          end
        else
          redirect_to welcome_company_register_path(confirm_member_token: @company_member.confirmation_token, email: @company_member.user_email) and return
        end
      else
        render 'company/company_members/company_member_confirmation',   layout: "company_member_confirm_layout"
      end
    end
  end

  #======================================
  #    Company Member Accpect 
  #======================================
  def company_member_accept
    company_member = Company::CompanyMember.find_by(confirmation_token: params[:confirmation_token])
    company_user = CompanyUser.find_by(email: company_member.user_email)

    unless company_member.present?
      redirect_to root_path and return
    else
      company_member.update(join_flag: 'true')
      company_member.update(join_date: Date.today)
      if company_user.present?
        company_member.update(user_id: company_user.id)	
        redirect_to new_company_user_session_path(email: company_member.user_email)
      else
        redirect_to welcome_company_register_path(confirm_member_token: params[:confirmation_token], email: company_member.user_email)
      end
    end
  end

  #======================================
  #    Company Member Reject  
  #======================================
  def company_member_reject
    company_member = Company::CompanyMember.find_by(confirmation_token: params[:confirmation_token])
    if company_member.present?
      company_member.destroy
    end
    redirect_to root_url
  end

  def save_img
    unless params[:company_company_member][:image_data].eql?"false"
      blob = convert_Base64_imgData(params[:company_company_member][:image_data])
      @company_company_member.image.attach(blob)
      params[:company_company_member][:image_data] = false
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_company_member
      @company_company_member = Company::CompanyMember.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_company_member_params
      params.require(:company_company_member).permit(:user_email, :department, :image, :position, :company_roles_id, :join_date)
    end
end
