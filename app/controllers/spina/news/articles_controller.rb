module Spina
  class News::ArticlesController < ::Spina::ApplicationController

    before_action :set_page
    before_action :find_articles, only: [:index]

    def index
      # if current_spina_user and current_spina_user.admin?
      #   @articles = @articles.unscope(where: :draft)
      # end

      respond_to do |format|
        format.atom
        format.html { render layout: "#{current_theme.name.parameterize.underscore}/application" }
      end
    end

    def show
      @article = Spina::News::Article.friendly.find params[:id]

      render layout: "#{current_theme.name.parameterize.underscore}/application"
    end

    def archive
      if params[:year] and params[:month]
        start = Time.new params[:year].to_i, params[:month].to_i
        finish = start.end_of_month
      elsif params[:year]
        start = Time.new params[:year].to_i
        finish = start.end_of_year
      end

      @articles = Spina::News::Article.live
        .where(published_at: start..finish)
        .order(published_at: :desc)
        .page(params[:page])

      render layout: "#{current_theme.name.parameterize.underscore}/application"
    end

    private

    def set_page
      @page = Spina::Page.find_or_create_by name: 'news' do |page|
        page.link_url = '/news'
        page.deletable = false
      end
    end

    def find_articles
      @articles = Spina::News::Article.available.live.order(published_at: :desc).page(params[:page])
    end
  end
end
