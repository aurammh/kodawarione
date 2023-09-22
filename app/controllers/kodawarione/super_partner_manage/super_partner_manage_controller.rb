class Kodawarione::SuperPartnerManage::SuperPartnerManageController < ApplicationController
  before_action :authenticate_admin!
  layout 'layouts/template/kodawarione'
  authorize_resource class: 'Kodawarione::SuperPartner'
  def index
    session[:created_super_partner_id] = nil
  end
end
