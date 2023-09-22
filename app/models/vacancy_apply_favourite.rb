class VacancyApplyFavourite < ApplicationRecord
    enum apply_status: { waiting_accept: 1, accept: 2, denied: 3 } 

    def self.apply_status_attributes_for_select 
        apply_statuses.map{ |k,v| [I18n.t("activerecord.attributes.#{model_name.i18n_key}.apply_statuses.#{k}"),v] }
    end
end