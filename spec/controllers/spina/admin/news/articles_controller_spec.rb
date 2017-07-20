require 'rails_helper'

RSpec.describe Spina::Admin::News::ArticlesController, type: :controller do
  let(:articles) { FactoryGirl.create_list :spina_news_article, 3 }
  let(:news_article) { FactoryGirl.create :spina_news_article }
  let(:draft_articles) { FactoryGirl.create_list :spina_news_article, 3, draft: true }
  let(:live_articles) { FactoryGirl.create_list :spina_news_article, 3, draft: false }
  let(:article_attributes) { FactoryGirl.attributes_for :spina_news_article }

  routes { Spina::Engine.routes }

  context 'signed in as an admin' do
    before { sign_in }

    describe 'GET #index' do
      subject { get :index }

      it { is_expected.to have_http_status :success }
      it { is_expected.to render_template :index }
      it {
        subject
        expect(assigns(:articles)).to match_array articles
      }
    end

    describe 'GET #live' do
      subject { get :live }

      it { is_expected.to have_http_status :success }
      it { is_expected.to render_template :index }
      it {
        subject
        expect(assigns(:articles)).to match_array live_articles
      }
      it {
        subject
        expect(assigns(:articles)).to_not match_array draft_articles
      }
    end

    describe 'GET #draft' do
      subject { get :draft }

      it { is_expected.to have_http_status :success }
      it { is_expected.to render_template :index }
      it {
        subject
        expect(assigns(:articles)).to match_array draft_articles
      }
      it {
        subject
        expect(assigns(:articles)).to_not match_array live_articles
      }
    end

    describe 'GET #future' do
      let(:past_articles) { FactoryGirl.create_list :spina_news_article, 3, published_at: Date.today - 10 }
      let(:future_articles) { FactoryGirl.create_list :spina_news_article, 3, published_at: Date.today + 10 }

      subject { get :future }

      it { is_expected.to have_http_status :success }
      it { is_expected.to render_template :index }
      it {
        subject
        expect(assigns(:articles)).to match_array future_articles
      }
      it {
        subject
        expect(assigns(:articles)).to_not match_array past_articles
      }
    end

    describe 'GET #new' do
      subject { get :new }

      it { is_expected.to have_http_status :success }
      it { is_expected.to render_template :new }
    end

    describe 'POST #create' do
      subject { post :create, params: { article: article_attributes } }

      it { is_expected.to have_http_status :redirect }
      it {
        subject
        expect(flash[:notice]).to eq 'Article saved'
      }
      it { expect{subject}.to change(Spina::News::Article, :count).by(1) }

      context 'with invalid attributes' do
        subject { post :create, params: { article: { content: 'foo' } } }

        it { is_expected.to_not have_http_status :redirect }
        it { expect{subject}.to_not change(Spina::News::Article, :count) }
        it { is_expected.to render_template :new }
      end
    end

    describe 'GET #edit' do
      subject { get :edit, params: { id: news_article.id } }

      it { is_expected.to have_http_status :success }
      it { is_expected.to render_template :edit }
    end

    describe 'PATCH #update' do
      subject { patch :update, params: { id: news_article.id, article: article_attributes } }

      it { is_expected.to have_http_status :redirect }
      it {
        subject
        expect(flash[:notice]).to eq 'Article saved'
      }
      it { expect{subject}.to change{news_article.reload.title} }

      context 'with invalid attributes' do
        subject { patch :update, params: { id: news_article.id, article: { title: '' } } }

        it { is_expected.to_not have_http_status :redirect }
        it { is_expected.to render_template :edit }
        it { expect{subject}.to_not change{news_article.reload.title} }
      end
    end

    describe 'DELETE #destroy' do
      let!(:news_article) { FactoryGirl.create :spina_news_article }

      subject { delete :destroy, params: { id: news_article.id } }

      it { expect{subject}.to change(Spina::News::Article, :count).by(-1) }
    end
  end

  context 'signed out' do
    describe 'GET #index' do
      subject { get :index }
      it { is_expected.to have_http_status :redirect }
      it { is_expected.to_not render_template :index }
    end
  end
end
