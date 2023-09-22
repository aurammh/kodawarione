class Kodawarione::NewsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_news, only: %i[ edit update show destroy]
  layout 'layouts/template/kodawarione'
  load_and_authorize_resource

  def index
    keyword = params[:keyword].blank? ? nil : params[:keyword].strip
    startDate = params[:startDate].blank? ? nil : params[:startDate]
    endDate = params[:endDate].blank? ? nil : params[:endDate]
    if startDate.blank? && !endDate.blank?
      @admin_news_result = Kodawarione::News.admin_news_search_by_date_to(endDate, keyword).where(query_with_current_role("news", "news_search"))
      elsif(!startDate.blank? && endDate.blank?)
        @admin_news_result = Kodawarione::News.admin_news_search_by_date_from(startDate, keyword).where(query_with_current_role("news", "news_search"))
      elsif(!startDate.blank? && !endDate.blank?)
        @admin_news_result = Kodawarione::News.admin_news_search_by_date_between(startDate, endDate, keyword).where(query_with_current_role("news", "news_search"))   
    else
      @admin_news_result = Kodawarione::News.admin_news_all_list(keyword).where(query_with_current_role("news", "news_search"))
    end 
    @news_results = Kaminari.paginate_array(@admin_news_result).page(params[:page]).per(12)
  end

  def new
    @news = Kodawarione::News.new
  end

  def create
    @news = Kodawarione::News.new(news_params)
    @news.news_type = set_admin_role_type
    @news.created_by_id = current_admin.id
    @news.created_user_id = current_admin.id

    respond_to do |format|
      if @news.save
        format.html { redirect_to kodawarione_news_index_path}
        format.json { render :show, status: :created, location: @news }
      else
        format.html { render :new}
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  #show corresponding news when click row on table
  def show
  end

  def edit
  end

  # PATCH/PUT /partner/news/1 or /partner/news/1.json
  def update
    respond_to do |format|
      if @news.update(news_params)
        format.html { redirect_to @news, notice: "New was successfully updated." }
        format.json { render :show, status: :ok, location: @news }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /partner/news/1 or /partner/news/1.json
  def destroy
    @news.update_columns(delete_flg: true)
    respond_to do |format|
      format.html { redirect_to kodawarione_news_index_path, notice: "Partner event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  
  def set_news
      @news = Kodawarione::News.find(params[:id])
  end

  def news_params
      params.require(:kodawarione_news).permit(:title, :news_category, :other, :created_admin_id, :updated_admin_id, :content, :show_option=> [] )
  end

end
