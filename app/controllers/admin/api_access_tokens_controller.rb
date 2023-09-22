class Admin::ApiAccessTokensController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_api_access_token, only: %i[edit update destroy ]
  layout 'layouts/template/admin'
  include CommonHelper

  # GET /admin/api_access_tokens or /admin/api_access_tokens.json
  def index
    @admin_api_access_token = Admin::ApiAccessToken.new
    @admin_api_access_tokens = Admin::ApiAccessToken.all.order(last_used_at: :desc)
    @admin_api_access_tokens = Kaminari.paginate_array(@admin_api_access_tokens).page(params[:page]).per(12)
  end

  # GET /admin/api_access_tokens/1 or /admin/api_access_tokens/1.json
  def show
  end

  # GET /admin/api_access_tokens/new
  def new
    @admin_api_access_token = Admin::ApiAccessToken.new
    params[:form_status] = "new"
    respond_to do |format|
      format.js {render 'admin/api_access_tokens/show_api_modal'}
      format.json { render json: @admin_api_access_token.errors}
    end
  end

  # GET /admin/api_access_tokens/1/edit
  def edit
    params[:form_status] = "update"
    respond_to do |format|
      format.js {render 'admin/api_access_tokens/show_api_modal'}
      format.json { render json: @admin_api_access_token.errors}
    end
  end

  # POST /admin/api_access_tokens or /admin/api_access_tokens.json
  def create
    @admin_api_access_token = Admin::ApiAccessToken.new(admin_api_access_token_params)
    token_scope = getJsonKey(params[:admin_api_access_token][:token_scope])
    @admin_api_access_token.token= Admin::ApiAccessToken.new.to_generate_token(params[:admin_api_access_token][:name])
    @admin_api_access_token.ip_address= "__IP-Address__"
    @admin_api_access_token.token_scope= token_scope
    @admin_api_access_token.created_admin_id= current_admin.id
    @admin_api_access_token.updated_admin_id= current_admin.id
    @admin_api_access_token.last_used_at= Time.current
    respond_to do |format|
      if @admin_api_access_token.save
        format.html { redirect_to admin_api_access_tokens_path, notice: "Api access token was successfully created." }
        format.json { render :index, status: :created, location: @admin_api_access_token }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_api_access_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/api_access_tokens/1 or /admin/api_access_tokens/1.json
  def update
    if params[:form_status] === "regenerate"
      params[:admin_api_access_token][:token] = Admin::ApiAccessToken.new.to_generate_token(params[:admin_api_access_token][:name])
    end
    token_scope = getJsonKey(params[:admin_api_access_token][:token_scope])
    params[:admin_api_access_token][:token_scope] = token_scope
    params[:admin_api_access_token][:created_admin_id]= current_admin.id
    params[:admin_api_access_token][:updated_admin_id]= current_admin.id
    params[:admin_api_access_token][:last_used_at]= Time.current
    respond_to do |format|
      if @admin_api_access_token.update(admin_api_access_token_params)
        format.html { redirect_to admin_api_access_tokens_path, notice: "Api access token was successfully updated." }
        format.json { render :index, status: :ok, location: @admin_api_access_token }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_api_access_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/api_access_tokens/1 or /admin/api_access_tokens/1.json
  def destroy
    @admin_api_access_token.destroy
    respond_to do |format|
      format.html { redirect_to admin_api_access_tokens_url, notice: "Api access token was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_api_access_token
      @admin_api_access_token = Admin::ApiAccessToken.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_api_access_token_params
      params.require(:admin_api_access_token).permit(:name,:token_type,:token,:ip_address,:created_admin_id,:updated_admin_id, :last_used_at,token_scope: [])
    end
end
