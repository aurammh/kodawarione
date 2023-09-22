class Communication::MailTemplateRegistrationsController < ApplicationController
  
  before_action :authenticate_company_user!, if: :company_user_signed_in?
  before_action :set_communication_mail_template_registration, only: %i[ show edit update destroy ]

  # GET /communication/mail_template_registrations or /communication/mail_template_registrations.json
  def index
    @communication_mail_template_registrations = Communication::MailTemplateRegistration.where("mail_template_registrations.company_id = '#{current_company.id}'").order(created_at: :desc)
    @communication_mail_template_registrations = Kaminari.paginate_array(@communication_mail_template_registrations).page(params[:page]).per(10)
  end

  # GET /communication/mail_template_registrations/1 or /communication/mail_template_registrations/1.json
  def show
  end

  # GET /communication/mail_template_registrations/new
  def new
    @communication_mail_template_registration = Communication::MailTemplateRegistration.new
  end

  # GET /communication/mail_template_registrations/1/edit
  def edit
  end

  # POST /communication/mail_template_registrations or /communication/mail_template_registrations.json
  def create
    @communication_mail_template_registration = Communication::MailTemplateRegistration.new(communication_mail_template_registration_params)
    @communication_mail_template_registration.company_id = @user_data.id
    respond_to do |format|
      if @communication_mail_template_registration.save
        format.html { redirect_to communication_mail_template_registrations_path, notice: "Mail template registration was successfully created." }
        format.json { render :show, status: :created, location: @communication_mail_template_registration }
        flash[:success] = [t('common.create_success'), t('mail_template_registration.title.header')]
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @communication_mail_template_registration.errors, status: :unprocessable_entity }
        flash[:error] = [t('common.create_error'), t('mail_template_registration.title.header')]
      end
    end
  end

  # PATCH/PUT /communication/mail_template_registrations/1 or /communication/mail_template_registrations/1.json
  def update
    respond_to do |format|
      if @communication_mail_template_registration.update(communication_mail_template_registration_params)
        format.html { redirect_to communication_mail_template_registrations_path, notice: "Mail template registration was successfully updated." }
        format.json { render :show, status: :ok, location: @communication_mail_template_registration }
        flash[:success] = [t('common.update_success'), t('mail_template_registration.title.header')]
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @communication_mail_template_registration.errors, status: :unprocessable_entity }
        flash[:error] = [t('common.update_error'), t('mail_template_registration.title.header')]
      end
    end
  end

  # DELETE /communication/mail_template_registrations/1 or /communication/mail_template_registrations/1.json
  def destroy
    @communication_mail_template_registration.destroy
    respond_to do |format|
      format.html { redirect_to communication_mail_template_registrations_url, notice: "Mail template registration was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_communication_mail_template_registration
      @communication_mail_template_registration = Communication::MailTemplateRegistration.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def communication_mail_template_registration_params
      params.require(:communication_mail_template_registration).permit(:template_name, :subject, :content)
    end
end
