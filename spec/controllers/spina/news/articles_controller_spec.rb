require 'rails_helper'

RSpec.describe Spina::News::ArticlesController, type: :controller do
  let!(:account) { ::Spina::Account.create name: 'MySite', theme: 'default' }

  routes { Spina::Engine.routes }

  let(:draft_past_articles) { FactoryGirl.create_list :spina_news_article, 3, draft: true, published_at: Date.today - 10 }
  let(:live_past_articles) { FactoryGirl.create_list :spina_news_article, 3, draft: false, published_at: Date.today - 10 }
  let(:live_future_articles) { FactoryGirl.create_list :spina_news_article, 3, draft: false, published_at: Date.today + 10 }

  describe 'GET #index' do
    subject { get :index }

    before do
      draft_past_articles
      live_past_articles
      live_future_articles
    end

    it {
      subject
      expect(assigns(:articles)).to match_array live_past_articles
    }
  end

  describe 'GET #show' do
    let(:news_article) { FactoryGirl.create :spina_news_article }

    subject { get :show, params: { id: news_article.id } }

    it {
      subject
      expect(assigns(:article)).to eq news_article
    }
    it { is_expected.to render_template :show }
    it { is_expected.to have_http_status :success }
  end

  describe 'GET #archive' do
    context 'with a year' do
      let(:this_year_articles) { FactoryGirl.create_list :spina_news_article, 3, draft: false, published_at: Date.today.beginning_of_year }
      let(:last_year_articles) { FactoryGirl.create_list :spina_news_article, 3, draft: false, published_at: Date.today.beginning_of_year - 1 }

      before do
        this_year_articles
        last_year_articles
      end

      subject { get :archive, params: { year: Date.today.year } }

      it {
        subject
        expect(assigns(:articles)).to match_array this_year_articles
      }
    end

    context 'with a year and a month' do
      let(:this_month_articles) { FactoryGirl.create_list :spina_news_article, 3, draft: false, published_at: Date.today.beginning_of_month }
      let(:last_month_articles) { FactoryGirl.create_list :spina_news_article, 3, draft: false, published_at: Date.today.beginning_of_month - 1 }

      before do
        this_month_articles
        last_month_articles
      end

      subject { get :archive, params: { year: Date.today.year, month: Date.today.month } }

      it {
        subject
        expect(assigns(:articles)).to match_array this_month_articles
      }
    end
  end
end
