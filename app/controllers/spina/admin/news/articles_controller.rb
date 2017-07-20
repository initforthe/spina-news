module Spina::Admin
  class News::ArticlesController < AdminController
    before_action :set_breadcrumb
    before_action :set_tabs, only: [:new, :create, :edit, :update]
    before_action :set_locale

    decorates_assigned :article

    layout 'spina/admin/news'

    def index
      @articles = Spina::News::Article.order(created_at: :desc)
    end

    def live
      @articles = Spina::News::Article.live.order(created_at: :desc)
      render :index
    end

    def draft
      @articles = Spina::News::Article.draft.order(created_at: :desc)
      render :index
    end

    def future
      @articles = Spina::News::Article.future.order(created_at: :desc)
      render :index
    end

    def new
      @article = Spina::News::Article.new
      add_breadcrumb I18n.t('spina.news.articles.new')
      render layout: 'spina/admin/admin'
    end

    def create
      @article = Spina::News::Article.new article_params
      if @article.save
        redirect_to spina.edit_admin_news_article_url(@article.id), notice: t('spina.news.articles.saved')
      else
        add_breadcrumb I18n.t('spina.news.articles.new')
        render :new, layout: 'spina/admin/admin'
      end
    end

    def edit
      @article = Spina::News::Article.find params[:id]
      add_breadcrumb @article.title
      render layout: 'spina/admin/admin'
    end

    def update
      I18n.locale = params[:locale] || I18n.default_locale
      @article = Spina::News::Article.find(params[:id])
      respond_to do |format|
        if @article.update_attributes(article_params)
          add_breadcrumb @article.title
          @article.touch
          I18n.locale = I18n.default_locale
          format.html { redirect_to spina.edit_admin_news_article_url(@article.id, params: {locale: @locale}), notice: t('spina.news.articles.saved') }
          format.js
        else
          format.html do
            render :edit, layout: 'spina/admin/admin'
          end
        end
      end
    end

    def destroy
      @article = Spina::News::Article.find(params[:id])
      @article.destroy
      redirect_to spina.admin_news_articles_path
    end

    private

    def set_breadcrumb
      add_breadcrumb I18n.t('spina.news.articles.title'), spina.admin_news_articles_path
    end

    def set_tabs
      @tabs = %w{article_content article_configuration}
    end

    def set_locale
      @locale = params[:locale] || I18n.default_locale
    end

    def article_params
      params.require(:article).permit(:title, :slug, :excerpt,
        :content, :photo_id, :draft, :published_at, :spina_user_id, :category_id)
    end

  end
end
