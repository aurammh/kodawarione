class Admin::ArticlesController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_admin_article, only: %i[ edit update show destroy]
    layout 'layouts/template/admin'

    def index
      keyword = params[:keyword].blank? ? nil : params[:keyword].strip
      startDate = params[:startDate].blank? ? nil : params[:startDate]
      endDate = params[:endDate].blank? ? nil : params[:endDate]
      if startDate.blank? && !endDate.blank?
        @admin_article_result = Admin::Article.admin_article_search_by_date_to(endDate, keyword)
        elsif(!startDate.blank? && endDate.blank?)
          @admin_article_result = Admin::Article.admin_article_search_by_date_from(startDate, keyword)
        elsif(!startDate.blank? && !endDate.blank?)
          @admin_article_result = Admin::Article.admin_article_search_by_date_between(startDate, endDate, keyword)   
      else
        @admin_article_result = Admin::Article.admin_article_all_list(keyword)
      end 
      @results = Kaminari.paginate_array(@admin_article_result).page(params[:page]).per(12)
    end

    def new
        @admin_article = Admin::Article.new
    end

    def show
        if @admin_article.video_link.present?
          @admin_article_video = Kaminari.paginate_array(@admin_article.video_link).page(params[:page]).per(4)
      end
    end

    def edit 
    end

    #update article information
    def update
      respond_to do |format|
        @admin_article.updated_admin_id= current_admin.id
        params[:admin_article][:video_link] = video_embed
        if @admin_article.update(admin_article_params)
          format.html { redirect_to admin_article_path(:id => @admin_article.id), notice: "Article was successfully updated." }
          format.json { render :show, status: :ok, location: @admin_article }
        else
          format.html { render :edit}
          format.json { render json: @admin_article.errors, status: :unprocessable_entity }
        end
      end
    end

    #save articles information
    def create
        @admin_article = Admin::Article.new(admin_article_params)
        @admin_article.created_admin_id= current_admin.id
        @admin_article.updated_admin_id= current_admin.id
        @admin_article.video_link = video_embed
        respond_to do |format|
          if @admin_article.save
            format.html { redirect_to admin_articles_path}
            format.json { render :show, status: :created, location: @admin_article }
          else
            format.html { render :new}
            format.json { render json: @admin_article.errors, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        @admin_article.update_columns(delete_flg: true)
        redirect_to admin_articles_path
      end

    private
    # get only video ID to save and update   
    def video_embed
        multi_video = []
        if params[:admin_article][:video_link] === [""]
          return  params[:admin_article][:video_link]
        end
      params[:admin_article][:video_link].each do |video_url|
        # REGEX PARA EXTRAER EL ID DEL VIDEO
          match_id = URL_VIDEO_ID.match(video_url)
          video_id = ""
          if match_id && !match_id[1].blank?
            video_id = match_id[1]
          elsif video_url.include? "drive.google.com"
            video_id = video_url.gsub(/https:\/\/drive\.google\.com\/file\/d\/(.*?)\/.*?\?usp=sharing/, 'https://drive.google.com/file/d/\1/preview')
          end
      
          # REGEX PARA EXTRAER EL PROVEEDOR - YOUTUBE/VIMEO
          match_prov = URL_VIDEO_PROV.match(video_url)
          video_prov = ""
          if match_prov && !match_prov[1].blank?
            video_prov = case match_prov[1]
                          when "youtube"
                            :youtube
                          when "youtu.be"
                            :youtube
                          when "vimeo"
                            :vimeo
                          when "drive.google.com"
                            :google
            end
          end
      
          case video_prov
            when :youtube
              multi_video << "https://www.youtube.com/embed/#{video_id}"
            when :vimeo
              multi_video << "https://player.vimeo.com/video/#{video_id}"
            when :google
              multi_video << "#{video_id}"
          end
      end
      if multi_video === []
         multi_video = [""] 
      end
      return multi_video
    end
  
    def set_admin_article
        @admin_article = Admin::Article.find(params[:id])
    end

    def admin_article_params
        params.require(:admin_article).permit(:title, :created_admin_id, :updated_admin_id, :content, :show_option, :video_link => [])
    end
end
