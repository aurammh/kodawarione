json.extract! company_activity, :id, :title, :company_id, :delete_flg, :created_at, :updated_at
json.url company_activity_url(company_activity, format: :json)
