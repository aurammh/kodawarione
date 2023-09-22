class Admin::ApiAccessToken < ApplicationRecord
    self.table_name  = "api_access_tokens"

    #enum for token_type options
    enum token_type_options: { type_a: 1, type_b: 2, type_c: 3}

    #enum for token_scope to allow permission
    enum token_scopes: { write: 1 }

    #to generate_api_token
    def to_generate_token(name)
        key = SecureRandom.base64(64)
        data = name+DateTime.now.to_s
        mac = OpenSSL::HMAC.hexdigest("SHA256", key, data)
        return mac
    end
end