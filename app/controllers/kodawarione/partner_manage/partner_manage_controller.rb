class Kodawarione::PartnerManage::PartnerManageController < ApplicationController
  before_action :authenticate_admin!
  layout 'layouts/template/kodawarione'
  authorize_resource class: 'Kodawarione::Partner'
  def index
    session[:created_partner_id] = nil
  end
end
