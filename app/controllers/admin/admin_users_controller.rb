class Admin::AdminUsersController < ApplicationController
  before_action :authenticate_admin!, except: %i[ new_genuie_password create_genuie_password]
  before_action :set_admin_user, only: %i[show edit update destroy]
  before_action :set__spu_token, only: %i[new_genuie_password create_genuie_password]
  layout 'layouts/template/admin'

  def index
    @admin_user = Admin.where(delete_flg: false)
    @admin_users = Kaminari.paginate_array(@admin_user).page(params[:page]).per(12)
  end

  def show
  end

  def new
    @admin_user = Admin.new
  end

  def create
    @admin_user = Admin.new(admin_user_params)
    @admin_user.check_password = true
    respond_to do |format|
      if @admin_user.save
        format.html { redirect_to admin_admin_users_path, notice: "Partner user was successfully created." }
        format.json { render :show, status: :created, location: @admin_user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  # PATCH/PUT /admin/partner_users/1 or /admin/partner_users/1.json
  def update
    respond_to do |format|
      if @admin_user.update(admin_user_params)
        format.html { redirect_to admin_admin_users_path, notice: "Partner user was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_user.update_columns(delete_flg: true)
    respond_to do |format|
      format.html { redirect_to admin_admin_users_path, notice: "Partner user was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # genuie_password
  def new_genuie_password
    render :layout => 'layouts/template/kodawarione'
    if @setting_user.genuine_password == true
      redirect_to root_path
    end
  end

  def create_genuie_password
    @setting_user.genuine_password = true
    respond_to do |format|
      if @setting_user.update(spu_genuine_password_params)
        sign_in(@setting_user)
        format.html {redirect_to(kodawarione_dashboard_index_path)}
        format.json { head :no_content }
      else
        format.html { render :new_genuie_password }
        format.json { render json: @setting_user.errors, status: :unprocessable_entity }  
      end
    end
  end

  private

  def set__spu_token
    @setting_user = Admin.confirm_by_token(params[:confirmation_token])
  end

  def set_admin_user
    @admin_user = Admin.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def admin_user_params
    params.require(:admin).permit(:first_name, :last_name, :email, :password, :password_confirmation )
  end

  def spu_genuine_password_params
    params.require(:admin).permit(:password, :password_confirmation, :confirmation_token, :genuine_password)
  end
end
