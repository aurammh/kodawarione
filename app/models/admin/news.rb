class Admin::News < ApplicationRecord
  has_rich_text :content
  has_one :action_text_rich_text,class_name: 'ActionText::RichText',as: :record
  self.table_name  = "admin_news"

  validates :title, length: { maximum: 255 }, presence: true
  validates :content, presence: true
  validates :news_type, presence: true
  validates :other, presence: true, if: :news_other_type_validation

  #enum for show_option options
  enum news_type: { important: 1, usually: 2, others: 3}

  news_column_name = ["body","title"]
  #search all list or with only keyword
  scope :admin_news_all_list, ->(keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{news_column_name.map {|field| "lower(regexp_replace(regexp_replace(#{field}, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    select('admin_news.*,action_text_rich_texts.body as content')
    .where("admin_news.delete_flg = 'false'" + keyword_search)
    .joins(:action_text_rich_text).order('admin_news.created_at desc')
  }

  #search with start date and keyword
  scope :admin_news_search_by_date_from, ->(startDate, keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{news_column_name.map {|field| "lower(regexp_replace(regexp_replace(#{field}, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    select("admin_news.*,action_text_rich_texts.body as content")
    .where("date(admin_news.created_at) >= '#{startDate}' AND admin_news.delete_flg  = 'false'" + keyword_search)
    .joins(:action_text_rich_text).order("created_at DESC")
  }

  #search with end date and keyword
  scope :admin_news_search_by_date_to, ->(endDate, keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{news_column_name.map {|field| "lower(regexp_replace(regexp_replace(#{field}, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    select("admin_news.*,action_text_rich_texts.body as content")
    .where("date(admin_news.created_at) <= '#{endDate}' AND admin_news.delete_flg  = 'false'" + keyword_search)
    .joins(:action_text_rich_text).order("created_at DESC")
  }

  #search with all fields
  scope :admin_news_search_by_date_between, ->(startDate,endDate, keyword){
    keyword_search = keyword.nil? ? '' : " AND (#{news_column_name.map {|field| "lower(regexp_replace(regexp_replace(#{field}, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g')) like lower('%#{keyword.gsub(/'/, "''") }%')"}.join(' or ')})"
    select("admin_news.*,action_text_rich_texts.body as content")
    .where("date(admin_news.created_at) >= '#{startDate}' AND date(admin_news.created_at) <= '#{endDate}' AND admin_news.delete_flg  = 'false'" + keyword_search)
    .joins(:action_text_rich_text).order("created_at DESC")
  }


  private

    def news_other_type_validation
        news_type == "others" ? true : false
    end
end
