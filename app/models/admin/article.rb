class Admin::Article < ApplicationRecord
    has_rich_text :content
    has_one :action_text_rich_text,class_name: 'ActionText::RichText',as: :record
    self.table_name  = "admin_articles"

    validates :title, length: { maximum: 255 }, presence: true
    validates :content, presence: true
    validates :show_option, presence: true

    #enum for show_option options
    enum show_option: { super_partner:5, partner: 4, company: 1, student: 2, all_user: 3}

    article_column_name = ["body","title","(CASE WHEN show_option = 1 THEN '#{I18n.t('admin.article.article_show_options.student')}' WHEN show_option = 2 THEN '#{I18n.t('admin.article.article_show_options.company')}' ELSE '#{I18n.t('admin.article.article_show_options.both')}' END)"]
    #search all list or with only keyword
    scope :admin_article_all_list, ->(keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{article_column_name.map {|field| "lower(regexp_replace(regexp_replace(#{field}, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    select('admin_articles.*,action_text_rich_texts.body as content')
    .where("admin_articles.delete_flg = 'false'" + keyword_search)
    .joins(:action_text_rich_text).order('admin_articles.created_at desc')
  }

    #search with start date and keyword
    scope :admin_article_search_by_date_from, ->(startDate, keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{article_column_name.map {|field| "lower(regexp_replace(regexp_replace(#{field}, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    select("admin_articles.*,action_text_rich_texts.body as content")
    .where("date(admin_articles.created_at) >= '#{startDate}' AND admin_articles.delete_flg  = 'false'" + keyword_search)
    .joins(:action_text_rich_text).order("created_at DESC")
  }

    #search with end date and keyword
    scope :admin_article_search_by_date_to, ->(endDate, keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{article_column_name.map {|field| "lower(regexp_replace(regexp_replace(#{field}, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    select("admin_articles.*,action_text_rich_texts.body as content")
    .where("date(admin_articles.created_at) <= '#{endDate}' AND admin_articles.delete_flg  = 'false'" + keyword_search)
    .joins(:action_text_rich_text).order("created_at DESC")
  }

    #search with all fields
    scope :admin_article_search_by_date_between, ->(startDate,endDate, keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{article_column_name.map {|field| "lower(regexp_replace(regexp_replace(#{field}, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    select("admin_articles.*,action_text_rich_texts.body as content")
    .where("date(admin_articles.created_at) >= '#{startDate}' AND date(admin_articles.created_at) <= '#{endDate}' AND admin_articles.delete_flg  = 'false'" + keyword_search)
    .joins(:action_text_rich_text).order("created_at DESC")
  }
end
