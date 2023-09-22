class Kodawarione::AdminRolesController < ApplicationController
  before_action :authenticate_admin!
  layout 'layouts/template/kodawarione'
  before_action :set_kodawarione_admin_role, only: %i[ show edit update destroy ]
  load_and_authorize_resource
  
  # GET /kodawarione/admin_roles or /kodawarione/admin_roles.json
  def index
    @kodawarione_admin_roles = Kodawarione::AdminRole.all

    @permission1 =  Kodawarione::RolePermission.select("permissions.permission_name,role_permissions.can")
                        .joins("INNER JOIN permissions ON permissions.id = role_permissions.permission_id")
                        .where("permissions.permission_for = 1 and role_permissions.role_id = 1").order("permission_id desc")

    @permission2 =  Kodawarione::RolePermission.select("permissions.permission_name,role_permissions.can")
                        .joins("INNER JOIN permissions ON permissions.id = role_permissions.permission_id")
                        .where("permissions.permission_for = 1 and role_permissions.role_id = 2").order("permission_id desc")

    @permission3 =  Kodawarione::RolePermission.select("permissions.permission_name,role_permissions.can")
                        .joins("INNER JOIN permissions ON permissions.id = role_permissions.permission_id")
                        .where("permissions.permission_for = 1 and role_permissions.role_id = 3").order("permission_id desc")                                         
  end

  # GET /kodawarione/admin_roles/1 or /kodawarione/admin_roles/1.json
  def show
  end

  # GET /kodawarione/admin_roles/new
  def new
    @kodawarione_admin_role = Kodawarione::AdminRole.new
  end

  # GET /kodawarione/admin_roles/1/edit
  def edit
  end

  def permission_categories
    @permission_groups = Kodawarione::Permission.select(:permission_group).where(permission_for: 1).order("permission_group asc").distinct
  end

  def permission_data 
    @permissions = Kodawarione::Permission.where(permission_group: params[:group_name])
    @role_permission = Kodawarione::RolePermission.permissions.where(role_id: params[:com_role_id])
  end

  def save_role_permission
    @permissions = Kodawarione::Permission.where(permission_group: params[:role_group_name], permission_for: 1)
    if Kodawarione::RolePermission.exists?(role_id: params[:role_id], permission_id: @permissions)
        permission_update(@permissions)
    else
        permission_role_setup(params[:role_id])
        permission_update(@permissions)
    end
    redirect_to kodawarione_permission_categories_path(:com_role_id => params[:role_id])
  end

  # POST /kodawarione/admin_roles or /kodawarione/admin_roles.json
  def create
    @kodawarione_admin_role = Kodawarione::AdminRole.new(kodawarione_admin_role_params)

    respond_to do |format|
      if @kodawarione_admin_role.save
        permission_role_setup(@kodawarione_admin_role.id)
        format.html { redirect_to @kodawarione_admin_role, notice: "Admin role was successfully created." }
        format.json { render :show, status: :created, location: @kodawarione_admin_role }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @kodawarione_admin_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kodawarione/admin_roles/1 or /kodawarione/admin_roles/1.json
  def update
    respond_to do |format|
      if @kodawarione_admin_role.update(kodawarione_admin_role_params)
        format.html { redirect_to @kodawarione_admin_role, notice: "Admin role was successfully updated." }
        format.json { render :show, status: :ok, location: @kodawarione_admin_role }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kodawarione_admin_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kodawarione/admin_roles/1 or /kodawarione/admin_roles/1.json
  def destroy
    @kodawarione_admin_role.destroy
    respond_to do |format|
      format.html { redirect_to kodawarione_admin_roles_url, notice: "Admin role was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kodawarione_admin_role
      @kodawarione_admin_role = Kodawarione::AdminRole.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kodawarione_admin_role_params
      params.require(:kodawarione_admin_role).permit(:role_type, :delete_flg)
    end

    def permission_role_setup(kodawarione_admin_role)
      @permissions = Kodawarione::Permission.where(permission_for: 1)
      @permissions.each do |permission|
          Kodawarione::RolePermission.new(role_id: kodawarione_admin_role, permission_id: permission.id, can: false).save
      end
    end

    def permission_update (permissions)
      permissions.each do |permission|
          role_permission = Kodawarione::RolePermission.where(role_id: params[:role_id], permission_id: permission.id)
          params[:permission_id].include?( permission.id.to_s) ? role_permission.update(can: true) : role_permission.update(can: false)
      end
    end
end
