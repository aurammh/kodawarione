class LogoutHistory < ApplicationRecord
  enum active_type: {
    company: 1,
    user: 2
  }, _prefix: true

  # Create or Update , Params = user_id, company_id
  def self.update_logout_history(user_id: ,company_id:)
    tbl_logout_history = LogoutHistory.find_by(company_user_id: user_id)
    if tbl_logout_history.present?
      tbl_logout_history.update({company_id: company_id})
    else
      new({company_user_id: user_id ,company_id: company_id}).save
    end
  end
end
