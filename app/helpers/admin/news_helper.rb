module Admin::NewsHelper
    def news_types
        Admin::News.news_types.keys.map{ |k| [t("partner_news.news_type_options.#{k}"), k] }
    end
end
