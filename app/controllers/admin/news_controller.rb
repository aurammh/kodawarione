class Admin::NewsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_admin_news, only: %i[ edit update show destroy]
    layout 'layouts/template/admin'

    #search news and show all news lists
    def index
        keyword = params[:keyword].blank? ? nil : params[:keyword].strip
        startDate = params[:startDate].blank? ? nil : params[:startDate]
        endDate = params[:endDate].blank? ? nil : params[:endDate]
      if startDate.blank? && !endDate.blank?
        @admin_news_result = Admin::News.admin_news_search_by_date_to(endDate, keyword)
        elsif(!startDate.blank? && endDate.blank?)
          @admin_news_result = Admin::News.admin_news_search_by_date_from(startDate, keyword)
        elsif(!startDate.blank? && !endDate.blank?)
          @admin_news_result = Admin::News.admin_news_search_by_date_between(startDate, endDate, keyword)   
      else
        @admin_news_result = Admin::News.admin_news_all_list(keyword)
      end 
      @results = Kaminari.paginate_array(@admin_news_result).page(params[:page]).per(12)
    end

    #new form to create news
    def new
        @admin_news = Admin::News.new
    end

    #show corresponding news when click row on table
    def show
    end

    #delete news when clcik delete button
    def destroy
      @admin_news.update_columns(delete_flg: true)
      redirect_to admin_news_index_path
    end

    def edit
    end

    #update news information
    def update
      respond_to do |format|
        @admin_news.updated_admin_id= current_admin.id
        if @admin_news.update(admin_news_params)
          format.html { redirect_to admin_news_path(:id => @admin_news.id), notice: "News was successfully updated." }
          format.json { render :show, status: :ok, location: @admin_news }
        else
          format.html { render :edit}
          format.json { render json: @admin_news.errors, status: :unprocessable_entity }
        end
      end
    end

    #save news information
    def create
        @admin_news = Admin::News.new(admin_news_params)
        @admin_news.created_admin_id= current_admin.id
        @admin_news.updated_admin_id= current_admin.id
    
        respond_to do |format|
          if @admin_news.save
            format.html { redirect_to admin_news_index_path}
            format.json { render :show, status: :created, location: @admin_news }
          else
            format.html { render :new}
            format.json { render json: @admin_news.errors, status: :unprocessable_entity }
          end
        end
      end

    private
  
    def set_admin_news
        @admin_news = Admin::News.find(params[:id])
    end

    def admin_news_params
        params.require(:admin_news).permit(:title, :news_type, :other, :created_admin_id, :updated_admin_id, :content)
    end
end