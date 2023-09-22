module Admin::ApiAccessTokensHelper
    #Api access token types option for combo box
  def token_type_options
    Admin::ApiAccessToken.token_type_options.map{ |k,v| [t("api_access_token.token_type_options.#{v}"), v] }
  end
end
