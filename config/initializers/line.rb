require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Line < OmniAuth::Strategies::OAuth2
      option :scope, 'email profile openid'
      info do
        {
          name:        raw_info['displayName'],
          image:       raw_info['pictureUrl'],
          description: raw_info['statusMessage'],
          email:    JWT.decode(access_token.params['id_token'], '7f0f99223a09e05cf6c2c26f81737101').first['email'] #追記
        }
      end
    end
  end
end