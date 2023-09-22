module Kodawarione::NewsHelper
    def news_categories
        Kodawarione::News.news_categories.keys.reverse.map{ |k| [t("partner_news.news_type_options.#{k}"), k] }
    end
    
    def news_types
        Kodawarione::News.news_types.keys.map{ |k| [t("partner_news.news_type_options.#{k}"), k] }
    end

    def kodawarione_news_show_options
        if current_admin.chief_administrator?
            Kodawarione::News.news_show_options.map{ |k,v| [t("partner_news.news_show_options.#{k}"), v] }
        elsif current_admin.super_partner?
            Kodawarione::News.news_show_options.map{ |k,v| [t("partner_news.news_show_options.#{k}"), v] if v > 1 }
        elsif current_admin.partner?
            Kodawarione::News.news_show_options.map{ |k,v| [t("partner_news.news_show_options.#{k}"), v] if v > 2 }
        end   
    end
end
