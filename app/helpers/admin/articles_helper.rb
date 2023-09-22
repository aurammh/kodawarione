module Admin::ArticlesHelper
    
    def admin_article_options
        Admin::Article.show_options.keys.map{ |k| [t("admin.article.article_show_options.#{k}"), k] }
    end

    def super_partner_article_options
        SuperPartnerUser::Article.show_options.keys.map{ |k| [t("admin.article.article_show_options.#{k}"), k] }
    end
    
    def partner_article_options
        Partner::Article.show_options.keys.map{ |k| [t("partner.article_show_options.#{k}"), k] }
    end
end
