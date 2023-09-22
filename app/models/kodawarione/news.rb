class Kodawarione::News < ApplicationRecord
    has_rich_text :content
    has_one :action_text_rich_text,class_name: 'ActionText::RichText',as: :record
    self.table_name = "news"

    #enum for show_option options
    enum news_category: { others:1, important: 2, usually: 3}

    #enum for show_option options
    enum news_show_option: {  super_partner: 1, partner: 2, company: 3, student: 4 }

    news_column_name = ["body","title"]
  #search all list or with only keyword
  scope :admin_news_all_list, ->(keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{news_column_name.map {|field| "lower(regexp_replace(regexp_replace(#{field}, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    select('news.*,action_text_rich_texts.body as content')
    .where("news.delete_flg = 'false'" + keyword_search)
    .joins(:action_text_rich_text)
    .order('news.created_at desc')
  }

  #search with start date and keyword
  scope :admin_news_search_by_date_from, ->(startDate, keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{news_column_name.map {|field| "lower(regexp_replace(regexp_replace(#{field}, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    select("news.*,action_text_rich_texts.body as content")
    .where("date(news.created_at) >= '#{startDate}' AND news.delete_flg  = 'false'" + keyword_search)
    .joins(:action_text_rich_text).order("created_at DESC")
  }

  #search with end date and keyword
  scope :admin_news_search_by_date_to, ->(endDate, keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{news_column_name.map {|field| "lower(regexp_replace(regexp_replace(#{field}, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    select("news.*,action_text_rich_texts.body as content")
    .where("date(news.created_at) <= '#{endDate}' AND news.delete_flg  = 'false'" + keyword_search)
    .joins(:action_text_rich_text).order("created_at DESC")
  }

  #search with all fields
  scope :admin_news_search_by_date_between, ->(startDate,endDate, keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{news_column_name.map {|field| "lower(regexp_replace(regexp_replace(#{field}, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    select("news.*,action_text_rich_texts.body as content")
    .where("date(news.created_at) >= '#{startDate}' AND date(news.created_at) <= '#{endDate}' AND news.delete_flg  = 'false'" + keyword_search)
    .joins(:action_text_rich_text).order("created_at DESC")
  }

    validates :title, length: { maximum: 255 }, presence: true
    validates :content, presence: true
    validates :news_category, presence: true
    validates :show_option, presence: true
    validates :other, presence: true, if: :news_category_validation

    private
    def news_category_validation
        news_category == "others" ? true : false
    end
end
