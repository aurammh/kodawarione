class Api::V1::ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  before_action :authenticate
  private
  def authenticate
    authenticate_user_with_token || handle_bad_authentication
    # authenticate_or_request_with_http_token do |token, options|
    #   # Compare the tokens in a time-constant manner, to mitigate
    #   # timing attacks.
    #   ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    # end
  end

  def authenticate_user_with_token
    authenticate_with_http_token  do |token, options|
      @api_access_token ||= Admin::ApiAccessToken.find_by(token: token)
    end
  end

  def handle_bad_authentication
    render json: { message: "Unable to authenticate you" }, status: :unauthorized
  end
  def handle_not_found
    render json: { message: "Record not found" }, status: :not_found
  end
end
